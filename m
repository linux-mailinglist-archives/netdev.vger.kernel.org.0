Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2DD158257
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 19:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbgBJSbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 13:31:23 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44157 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbgBJSbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 13:31:23 -0500
Received: by mail-pg1-f194.google.com with SMTP id g3so4335368pgs.11
        for <netdev@vger.kernel.org>; Mon, 10 Feb 2020 10:31:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Zdrp+JloS65aUB9YJGRF8WCmX1FO/76dXjWXnvFhtwY=;
        b=Ghn0LYu0clBXqkFFrCnnZ9eq0zjZU5svu4SNBqd+02BZIJb+5sefVDq4Kernpyb745
         ddvxgy66AAikxGwwAb9vAQSIVlfJbwejofPdjwB80GMIj9jmbBOox0O7v1HvE+1IxWJx
         vMdAu1AK5HRuHtKXthfsX6WzF4GXHtygjOTDq3N1z+Hzr8Jf+CECNBT62dIYagORCkpY
         miRQcWM6y1VeCHI8hsWqyPSTYJ4sqYnV6CorAeDAvfC+qzWt6f5gHDBnpSV79CvcvIpW
         HZD6krIwYxDiPuphY18DVarSlshPzwzx5DTNMoexd2eytQqComaYcYk7zAkfQ/WZo52Y
         Bajg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Zdrp+JloS65aUB9YJGRF8WCmX1FO/76dXjWXnvFhtwY=;
        b=nr5NfHUUWFaMkrl5IBXyX4lBeUZkJaH2xWRK8ZLpJRKHgPbo4ForOWB7L8zplgtyng
         UlScq+JymhBPJjOKi+dI7t0lleDfJ7CopwKVew26FKX5ime48pfPvhk1QP9N1w0RBAtp
         oolWukxIkedGa8mGDGmD2/76wvI1xhQPtFXBtppm2pfd39wS0FQRcEkD8bKzEqZ/qJ3V
         qcRAz1s69ljjQxLL6U19UCi+KXaCtN0NE56UDqJYaB7jqpE/YKG5r16l/Z3sRsbSD3QL
         vbNKiMEIv8iLy/h0L5yd9kYUWLaV1UHe27KrJzjsIp29gJtXGKGOGzNqav61bUWSGPqx
         c9uQ==
X-Gm-Message-State: APjAAAW8K4BSBD+8Vz0Gzuo4GTgTn1vrJxXwvqRNZskmDpOiHbceqLT6
        T5R0x1AlP3NTo4WA9J2QGCd8+Qdc
X-Google-Smtp-Source: APXvYqxXW0G7IaYrd1dDbd6rlUuvhu20XIYmDDFe8m+j6SoF+KarRsUIFsphsm/wR6OuiB/nsfrxxg==
X-Received: by 2002:aa7:9301:: with SMTP id 1mr2352573pfj.156.1581359481466;
        Mon, 10 Feb 2020 10:31:21 -0800 (PST)
Received: from ?IPv6:2620:101:c040:85c:dc99:54c6:d71:871e? ([2620:101:c040:85c:dc99:54c6:d71:871e])
        by smtp.gmail.com with ESMTPSA id e84sm1069954pfh.149.2020.02.10.10.31.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Feb 2020 10:31:21 -0800 (PST)
Subject: Re: [PATCH] staging: qlge: Fixed extra indentation in
 qlget_get_stats()
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     netdev@vger.kernel.org
References: <20200209073621.30026-1-jrtknauer@gmail.com>
 <20200210043158.GA3258@f3>
From:   Jarrett Knauer <jrtknauer@gmail.com>
Message-ID: <45451eb8-e6a9-2e7a-e2fd-680b31e38717@gmail.com>
Date:   Mon, 10 Feb 2020 11:31:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200210043158.GA3258@f3>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-02-09 9:31 p.m., Benjamin Poirier wrote:
> On 2020/02/09 00:36 -0700, Jarrett Knauer wrote:
>> qlge TODO cited weird indentation all over qlge files, with
>> qlget_get_stats() as an example. With this fix the TODO will need to be
>> updated as well.
>>
>> This is also a re-submission, as I incorrectly sent my first patch
>> directly to the maintainers instead of to the correct mailing list.
>> Apologies.
> If you really want to fix this, I would suggest to go over all of the
> driver at once. Then you can remove the TODO entry.
I can do this. Would it be best for me to re-submit this patch in a series of patches with each indentation fix that I go through + a cover letter for the series?
