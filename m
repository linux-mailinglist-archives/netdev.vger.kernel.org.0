Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B20C16BAE2
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 08:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729528AbgBYHkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 02:40:25 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40650 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729294AbgBYHkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 02:40:24 -0500
Received: by mail-wr1-f67.google.com with SMTP id t3so13405675wru.7
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 23:40:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Hho5/kvAE1CzyZa7IH8cpY/xFj/G+aGhGEJjNVsH7NE=;
        b=TORtx2aMqMHuSyOWPKBtkXJlOg2SlvvTtEvDcX2u0DxeB46u5GC32Os4bN5uj+cdkq
         52KEtbku607B8Z1+eKers4f4mKEUWruaUYeFG7on6v0hzfFy6D+X3fAEvpa3Bq0XJKYf
         ppJu5IUJ5hb4TNs4uYoSck2W2BJmN+8OnV1031JBGG+If1/n/qGj02OJZz2reUxRxOJ9
         RY7iiUig2FJNbj7sG/EPF5ocWuu+9y7F2GO9qEypGRgQO+b+F9Qz4RkCWhVwtlt/ipxJ
         2X5+JckPp80Ed5PF7icy2ZipL6lNgIEfF+HnZbNwAoYi8HK0+xdnC9nGxkJjq98wvTlf
         r0PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Hho5/kvAE1CzyZa7IH8cpY/xFj/G+aGhGEJjNVsH7NE=;
        b=DSFNdPNPNoHgXLtt+iHytcq2VxYIzJ/sL4GdPORXl3ha1Vl3WATvUIb3tscxVNwbhg
         ZSCLAd+QnhYiF9T7ZyEqndWZtdxklLiRzlniIapPD/7f6Ck0qdXK3xyRBdxgj1HxqUoe
         AtzTESHkjg4euqepM1XmmHH01Yfkl3gaURTGyKu3QdQE1bw4H6j9mWbwY9oPuvDIaQVT
         Q0F9LfgxLV5vfQa+R6tDDNowJ6YmwYk7FIOzJNsVp+H0vKaQ/sHokk5/7tbqmJnqzw4S
         OLFjaXLWYY3MjM9RKzLMzc6AHqGZWbt8DLUX9ZRbPB2Ul546dW7bc7K4wLwnlagOkjoG
         nMZw==
X-Gm-Message-State: APjAAAVvTI6yp3o7T3bW3qZJ9HYpHp/VpdGZ6y6byABZEEfNG+SdU0D0
        ZwoAtabphdP4R+86ULe/AxGaQw==
X-Google-Smtp-Source: APXvYqwdIlqSZjql8gseT4w0uHDWtiCg9SosCNnR3UIUFlCE3kNNv4Jf47qXJylcN1YGN+1IvuDbrw==
X-Received: by 2002:adf:f7c6:: with SMTP id a6mr74764295wrq.164.1582616421362;
        Mon, 24 Feb 2020 23:40:21 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id z1sm2926145wmf.42.2020.02.24.23.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 23:40:20 -0800 (PST)
Date:   Tue, 25 Feb 2020 08:40:19 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next 09/10] netdevsim: add ACL trap reporting cookie
 as a metadata
Message-ID: <20200225074019.GB17869@nanopsycho>
References: <20200224210758.18481-1-jiri@resnulli.us>
 <20200224210758.18481-10-jiri@resnulli.us>
 <20200224204257.07c7456f@cakuba.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224204257.07c7456f@cakuba.hsd1.ca.comcast.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Feb 25, 2020 at 05:42:57AM CET, kuba@kernel.org wrote:
>On Mon, 24 Feb 2020 22:07:57 +0100, Jiri Pirko wrote:
>> +static ssize_t nsim_dev_trap_fa_cookie_write(struct file *file,
>> +					     const char __user *data,
>> +					     size_t count, loff_t *ppos)
>> +{
>> +	struct nsim_dev *nsim_dev = file->private_data;
>> +	struct flow_action_cookie *fa_cookie;
>> +	size_t cookie_len = count / 2;
>> +	ssize_t ret;
>> +	char *buf;
>> +
>> +	if (*ppos != 0)
>> +		return 0;
>
>return 0? Should this not be an error?

Correct. Changed to return -EINVAL;


>
>> +	cookie_len = (count - 1) / 2;
>
>why was cookie_len initialized when it was declared? 

Forgotten init. Fixed.


>
>> +	if ((count - 1) % 2)
>> +		return -EINVAL;
>> +	buf = kmalloc(count, GFP_KERNEL);
>
>Strangely the malloc below has a NOWARN, but this one doesn't?

Added nowarn flag here too.


>
>> +	if (!buf)
>> +		return -ENOMEM;
>> +
>> +	ret = simple_write_to_buffer(buf, count, ppos, data, count);
>> +	if (ret < 0)
>> +		goto err_write_to_buffer;
>> +
>> +	fa_cookie = kmalloc(sizeof(*fa_cookie) + cookie_len,
>> +			    GFP_KERNEL | __GFP_NOWARN);
>> +	if (!fa_cookie) {
>> +		ret = -ENOMEM;
>> +		goto err_alloc_cookie;
>> +	}
>> +
>> +	fa_cookie->cookie_len = cookie_len;
>> +	ret = hex2bin((u8 *) fa_cookie->cookie, buf, cookie_len);
>
>this u8 cast won't be necessary if type of cookie changes :)

Removed.


>
>Also I feel like we could just hold onto the ASCII hex buf, 
>and simplify the reading side. If the hex part is needed in 
>the first place, hexdump and xxd exist..

I don't understand. Do you suggest to keep the write hex "buf" as well
and just print it out in "read()" function? I don't like to store one
info in 2 places. We need to have the cookie in fa_cookie anyway. Easy
to bin2hex from it and send to userspace.


>
>> +	if (ret)
>> +		goto err_hex2bin;
>> +	kfree(buf);
>> +
>> +	spin_lock(&nsim_dev->fa_cookie_lock);
>> +	kfree(nsim_dev->fa_cookie);
>> +	nsim_dev->fa_cookie = fa_cookie;
>> +	spin_unlock(&nsim_dev->fa_cookie_lock);
>> +
>> +	return count;
>> +
>> +err_hex2bin:
>> +	kfree(fa_cookie);
>> +err_alloc_cookie:
>> +err_write_to_buffer:
>
>Error labels should be named after what they undo, not after
>destination. That makes both the source and target of the jump 
>easy to review.

Well, it's a matter of a code you look at. I actually like it better
with err_*. Anyway, netdevsim uses the convention you want, changed.


Thanks for review!

>
>> +	kfree(buf);
>> +	return ret;
>> +}
