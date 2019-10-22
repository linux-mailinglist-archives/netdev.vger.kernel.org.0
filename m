Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE9A9E0D3A
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 22:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388344AbfJVU33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 16:29:29 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38896 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728832AbfJVU32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 16:29:28 -0400
Received: by mail-lj1-f196.google.com with SMTP id q78so3481819lje.5
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 13:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=NovAOSnJkjSpelcbLE/Ws4KDhSSFDNoFlL7FMJMTi0k=;
        b=t3jidYtbAgpqYIUhdpbrdKPhGtENL1+5ot7OAe7W+hVZhj1IkMrfd+/1C4u6XVS8J6
         mzmnttXiCSUZm85ptFoomC/H1M8KKhwVPkuuvJ6JJosdxvAv8Oo/mb+Y8GbHQTWgr+FR
         Ftdm1ajzuSNMjZ6L7ZfXzeM02467os2U0UDinfx7U293z+vGTz3oh8WVYRX3B0GyIKB6
         x9mQvr6xI9HhlSbK6LvFzp9Sk3Zk5Ne1PFjj+W3aNcaKvFv2/MiPlG+UdyK90+Frzw8+
         FQ5U97PXAdX9zMNFTCFzBBLXtLdgLI8i1JG1N/g9CLKk3EpMtjfqQ3y43dbhwcyVoe+F
         q3/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=NovAOSnJkjSpelcbLE/Ws4KDhSSFDNoFlL7FMJMTi0k=;
        b=rqCAReqiKKJ3DYwmefMDONr0luKF3JHJISY/RhNyLCYo/PWy7R9wcmJZDcUje0FCYh
         KLcMmixBkpJSW6oRAPCJ3qRTEoEtO82rtrrWS10YqN7maU4c7pa7sWUzjopte2EeihG6
         NtREf7mINEkwudr4wX67B4egVWw6acPR3L0SCtPWyQUHajIcMayzbxG576oDDzA1LbFl
         /UmAg+SUYLB6HX3eFGwuHc3RqCYr3RY5FIRCO8erraXm7Svnh3u40tA18W2FJNjH1hyl
         2nbXH9MBEquFrWbz7y5S6AND/CkX5MK2rLvF147WiPbbO94/pQMmzTB3Ys12sDPRz4Wc
         nZdQ==
X-Gm-Message-State: APjAAAWWB1g5oVFnoUe3L4H9WP7PzreAgzE4kaj1f9UQ3TFTideHDV77
        iLBR2N3PnsDOJzDeVhqG8blLhg==
X-Google-Smtp-Source: APXvYqyPSAuql9cwfn4M//J4FZnrUIpj2SMp2C3LUlrQyVPh1WJCO4Kz5sij6MmTisACfjt8y4WhPg==
X-Received: by 2002:a2e:7c13:: with SMTP id x19mr5160033ljc.0.1571776166227;
        Tue, 22 Oct 2019 13:29:26 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g27sm8633468lja.33.2019.10.22.13.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 13:29:25 -0700 (PDT)
Date:   Tue, 22 Oct 2019 13:29:19 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        vasundhara-v.volam@broadcom.com
Subject: Re: [PATCH net 0/5] bnxt_en: Bug fixes.
Message-ID: <20191022132919.021d8a09@cakuba.netronome.com>
In-Reply-To: <1571636069-14179-1-git-send-email-michael.chan@broadcom.com>
References: <1571636069-14179-1-git-send-email-michael.chan@broadcom.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Oct 2019 01:34:24 -0400, Michael Chan wrote:
> Devlink and error recovery bug fix patches.  Most of the work is by
> Vasundhara Volam.  

Thanks, applied.

> Please queue patch 1 and 2 for -stable also.  Thanks.

FWIW these will likely only reach 5.3 since it looks like the bug dates
to 5.1 but 5.1 and 5.2 branches of stable are already EOL.
