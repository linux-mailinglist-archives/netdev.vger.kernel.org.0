Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 113E539BF4
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 11:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfFHJCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 05:02:38 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43990 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfFHJCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 05:02:38 -0400
Received: by mail-lj1-f196.google.com with SMTP id 16so3728907ljv.10
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 02:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JzD57XsNsm4T7ciYV5qAxbKzPpS/622/plyPfoUuaT0=;
        b=C3LPbh6zTpgqdqk1OabHi1qwjbCKMi4gaYbeys2nVnl4pGPLey+8dynI2K7xi1sOZ7
         7kilIHsGQHMsO/3CXODaKyLGjL76aSAuP0ZePR37J1FBBHcGCFtn6dZ8seqkOkeg5Yf+
         FpY98pgGt3qKKyFs+HgKMTnQYuFHs52bDgm4hJm6XtEpCGU4Bt6QtWOzUmdBOt7Mx6F+
         ZfVl2tZIh0kDg5Q+V51yF3WglMFURPFUYppddySrGiVfe/1+LPDLvM6TufL1jAHMd/LW
         CV3O53V1ZewQUQs373j540+TLC2t2WEfg9hSnDOZ44mBhwJrzMDzoHS8POF74kVghPGC
         QKmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JzD57XsNsm4T7ciYV5qAxbKzPpS/622/plyPfoUuaT0=;
        b=Rfd6WqDKwQuasBUUWQ9TNpjUW72nkwCxrDjOcj2b34kyREQOpQUU3l0yoTUEX3Uag4
         fezM2j1WYXz13Xp6GvyUr8v2PbZzzBCAdSO4UT893gcnML41tLQTIcXibx+aciUieOq6
         XJGO0+O4XbfLAmsnEUxZdwJ852bB6uMjHVV98XWneUOkTm9vZaBbFYW01LFvR48LcnUt
         1OPhRfvRhTEs16VPqAymd4kBUo3MXzk4KVCPIlJG1+sXAYT+56O9LXBtSD8USzBBXbLg
         GQc8QXeT1mZqlzEmZ6mUhR4CybPhq93iD0AFvJFR686jvAS3TyZ6PWauaBYMi6wOxLCE
         V5dQ==
X-Gm-Message-State: APjAAAVb4ffYCVfa/4K94fatIFsHPRpx5kPMuXnAXe/h6SK2KCT0CM2b
        Gsr7ygbtCfCNIeibAl4bW1WWZw==
X-Google-Smtp-Source: APXvYqyd/kqa4qiFi5uydOKSbaqImtCipAE28cplnv2D2I+Q+J4RNDokGouhWvLF1V62y8Gj1urz4A==
X-Received: by 2002:a2e:9ad1:: with SMTP id p17mr31017948ljj.147.1559984556669;
        Sat, 08 Jun 2019 02:02:36 -0700 (PDT)
Received: from [192.168.0.199] ([31.173.83.119])
        by smtp.gmail.com with ESMTPSA id t13sm771408lji.47.2019.06.08.02.02.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 02:02:35 -0700 (PDT)
Subject: Re: [PATCH trivial] qed: Spelling s/configuraion/configuration/
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Ariel Elior <aelior@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Kosina <trivial@kernel.org>
Cc:     GR-everest-linux-l2@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190607112516.13717-1-geert+renesas@glider.be>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <115096b5-8614-7f0e-e49b-0a71555f18d7@cogentembedded.com>
Date:   Sat, 8 Jun 2019 12:02:33 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190607112516.13717-1-geert+renesas@glider.be>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

    Again, typo in the subject. :-)

On 07.06.2019 14:25, Geert Uytterhoeven wrote:

> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be
[...]

MBR, Sergei
