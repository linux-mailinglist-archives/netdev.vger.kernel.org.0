Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB4B75797
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 21:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbfGYTKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 15:10:36 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45888 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfGYTKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 15:10:36 -0400
Received: by mail-qk1-f193.google.com with SMTP id s22so37302597qkj.12
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 12:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=iKVapx1RqpxI4fC/IeFwmqp7E16OG+D1ofg7IIrvhQg=;
        b=vUWKD0RRiPRmwMu/QH7xCx/r3e2UNByUpx8QWn0jCjt1aud5Ui1164+ZPJfueeId+7
         Tm4oSPV5SR56aOKAUDbKg8KXkSoM11yY28/DK4nhE+ayk09JyOpuujXjBZVfHPF0fsbL
         4neSq/zNQL4gLYctF1ZtffxR9J7BAJ694o0BFnVhmBSxqDB5Q8l8U2vtE1mw7CTuxdx6
         5XSRacQ/BN7dGwYYx7y39QhGR+A5v53OqjwE2Djf8Po+Cyen+XoI055Ks89OdRCN7ooE
         izHL+pvDvuGGwu6ZLaomIYAw5kAZCfa7sHvNWDFhJxMuUthuDjL/xP262twclHOuxhjr
         QeUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=iKVapx1RqpxI4fC/IeFwmqp7E16OG+D1ofg7IIrvhQg=;
        b=AdQtewvInewfEVUXYvVc6nsW1pSbM1JpXNsjb9g/zX11p+0GuCabdfHj5/wxYsEmK3
         eVUQaXZZZ+Dmpm+rlZlMb9gQkyLwC5cWm1DGKGKRCGk8Dbu9g43qNuIF+uY+W9SJibxR
         gRnIOsjkEmSq7V81WsSV8SOY7zaVQU0mKgP6om3eqgsS2pijUnqpCjE/pOdhmN+mbe7n
         YrKPktbnq/ZG3eRA51XB0UyAOgOaYkfgFJ4SdsbPymbTsP1y39IQwxol8Cn1I2xarOHu
         q9lf4JTgU+6tly5juCx6yQjgMhAj0lKKPFKl0HtOoSQcOa36cM2ad3fw+bYJ/OuQxm6b
         +qCQ==
X-Gm-Message-State: APjAAAX3agbM7jwtQlMej3olo1T6V+T8h3uL8jwr2hGkhCY7KYJ/pffs
        nQMXEew0J5jQHnDT7lJ2+s4MnQ==
X-Google-Smtp-Source: APXvYqzqFw9CSlMSLMTe/OvgGUoYAX8lbHzh+recHR3EUzWUU00tGD6X5MxRRe0L8xiWCcnrzb/YQw==
X-Received: by 2002:a37:aa04:: with SMTP id t4mr59931514qke.359.1564081835202;
        Thu, 25 Jul 2019 12:10:35 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y3sm24473960qtj.46.2019.07.25.12.10.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 12:10:35 -0700 (PDT)
Date:   Thu, 25 Jul 2019 12:10:29 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     wenxu@ucloud.cn
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] flow_offload: move tc indirect block to
 flow offload
Message-ID: <20190725121029.75f26c2d@cakuba.netronome.com>
In-Reply-To: <1564048533-27283-1-git-send-email-wenxu@ucloud.cn>
References: <1564048533-27283-1-git-send-email-wenxu@ucloud.cn>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please provide cover letter for the patch set.

On Thu, 25 Jul 2019 17:55:31 +0800, wenxu@ucloud.cn wrote:
> +static bool rhash_table_init;
> +int flow_indr_rhashtable_init(void)
> +{
> +	int err = 0;
> +
> +	if (!rhash_table_init) {
> +		err = rhashtable_init(&indr_setup_block_ht,
> +				      &flow_indr_setup_block_ht_params);
> +
> +		if (!err)
> +			rhash_table_init = true;
> +	}
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(flow_indr_rhashtable_init);

This should be written like this:

int flow_indr_rhashtable_init(void)
{
	static bool rhash_table_init;
	int err;

	if (rhash_table_init)
		return 0;

	err = rhashtable_init(&indr_setup_block_ht,
			      &flow_indr_setup_block_ht_params);
	if (err)
		return err;

	rhash_table_init = true;
	return 0;
}
EXPORT_SYMBOL_GPL(flow_indr_rhashtable_init);
