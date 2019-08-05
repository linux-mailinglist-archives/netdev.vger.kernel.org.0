Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF3081F84
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 16:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729623AbfHEOvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 10:51:25 -0400
Received: from mail-io1-f45.google.com ([209.85.166.45]:39390 "EHLO
        mail-io1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728952AbfHEOvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 10:51:25 -0400
Received: by mail-io1-f45.google.com with SMTP id f4so167938760ioh.6
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 07:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=S/QwC8ze48ic4gWZYTgHfpsCodN3M2v1NuMgkbqX7P4=;
        b=Drgbke3ixrpZ1j6Er40tMOHd454gqVZZFlbbVouPvXMCwaW0RLDqqmGj4oanyPzwYt
         VnJ0LExvsAGPk9xz/jDWLGwZ6NsfpSjb97gINKLnX6jKTv3xdC2hNIrt74ZPah6MjcE8
         OvIzSKZnx0OXkjkmIkTanWrpVsouaP281/9wJ5g/oimGygkXZ9UUvfyNnjlwQv8QOYPt
         +gSzP1ZUEFQ7SbqJJqKlywPs7kPvOAJUZN9fTdMBzIyZuKHDGF1VXtPu25BK33NVobB5
         B4D+DIo993EYqxUW2mfU0/ciQfgV+gN1qFxgiSd2PY/BFe9xE2s8ObPxSNmH0VuVoOPy
         qPBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S/QwC8ze48ic4gWZYTgHfpsCodN3M2v1NuMgkbqX7P4=;
        b=muZ5lZfv9V/Y8amkZStC1VACtnSEsXkbk1nm9w86JvMGItkiSsDXubPTesqJwNd7vD
         TaKZni58uRXsSAZNJiYEQnMwwHXSaYJTZ30Wvoini+UfUhOURW6EVEMtdpNyKi1sQftz
         AhlDmV8kt4ZrP1X3Z2tdU6sBWCab/6BWdufDjSDQzwIoVS6D0f4ez2sGCuXvQinv33mk
         49lXRHJ4IpBJ70NjwYfcwlbp98i6WllXhm7VAA6f1rwxuQ5dXdPcJv4xvDoIjmcOSBkJ
         OZPS9TaCGP/sTvuzzgxqp6tQlIH1mrVZsBM/WszYLx72ZTEXTMnqJT4+Zwn/KOobmGTQ
         UW1A==
X-Gm-Message-State: APjAAAWvvIb3yosKGdXFBes7M0xZ9+jrBhOaig8T61CmR9SwfLq6zM5y
        utnaTfZvQ+a84bGaYrOie20=
X-Google-Smtp-Source: APXvYqyAWizleb/n/o9PdGQ/M0uRYQpkUop/uM035UdRth95ZMd1n8C/ff21BLKHdmCxEzP9ya8YyQ==
X-Received: by 2002:a5d:8e16:: with SMTP id e22mr13753485iod.171.1565016684952;
        Mon, 05 Aug 2019 07:51:24 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:ca5:ef3d:7276:749b? ([2601:282:800:fd80:ca5:ef3d:7276:749b])
        by smtp.googlemail.com with ESMTPSA id j25sm112784872ioj.67.2019.08.05.07.51.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 07:51:24 -0700 (PDT)
Subject: Re: [patch net-next v2 1/3] net: devlink: allow to change namespaces
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, mlxsw@mellanox.com
References: <20190730153952.73de7f00@cakuba.netronome.com>
 <20190731192627.GB2324@nanopsycho>
 <c4f83be2-adee-1595-f241-de4c26ea55ca@gmail.com>
 <20190731194502.GC2324@nanopsycho>
 <087f584d-06c5-f4b9-722b-ccb72ce0e5de@gmail.com>
 <89dc6908-68b8-5b0d-0ef7-1eaf1e4e886b@gmail.com>
 <20190802074838.GC2203@nanopsycho>
 <6f05d200-49d4-4eb1-cd69-bd88cf8b0167@gmail.com>
 <20190805055422.GA2349@nanopsycho.orion>
 <796ba97c-9915-9a44-e933-4a7e22aaef2e@gmail.com>
 <20190805144927.GD2349@nanopsycho.orion>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <566cdf6c-dafc-fb3e-bd94-b75eba3488b5@gmail.com>
Date:   Mon, 5 Aug 2019 08:51:22 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190805144927.GD2349@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/5/19 8:49 AM, Jiri Pirko wrote:
>> Your commit 5fc494225c1eb81309cc4c91f183cd30e4edb674 changed that from a
>> per-namepace accounting to all namespaces managed by a single devlink
>> instance in init_net - which is completely wrong.
> No. Not "all namespaces". Only the one where the devlink is. And that is
> always init_net, until this patchset.
> 
> 

Jiri: your change to fib.c does not take into account namespace when
doing rules and routes accounting. you broke it. fix it.
