Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA00C100DAA
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 22:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfKRV22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 16:28:28 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37081 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbfKRV21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 16:28:27 -0500
Received: by mail-lf1-f68.google.com with SMTP id b20so15095996lfp.4
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 13:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=/vxN4WRqFE5DWksE0LR7UJt1n7+iW6YVW5cE3jC4KGk=;
        b=Wq2Lpi528GOEipIKSRM/u5w/H3olumlpQWwnfVvombaWYKFZBdGgKuBMQHT6VmtTP4
         flTyk6ZWa9Z+71k5Bu6Bd21WPj5fYvq+ElCD8jD4c0dg5PN0oPgglVTdnX8pC3sHJc/r
         YIFWDkRnfPRAAob13LxcyYK4ufoZcy0mlqXPvzrD1jgXGmOV1Je3FKJNXtaJNnwz03Jy
         txzv7r+hC3Rz3wYTwNU/xqGvPBmnk4LrjEv6QdbSaRbMAJGUQJ4sfaYjWg0eqlA/xgrA
         J9sHR278eifhap9NygVTc3fO3ZmHkOLvOJqtaHfepNSek75BMFwxLHMnFLGOn4mPwKtQ
         Xqdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=/vxN4WRqFE5DWksE0LR7UJt1n7+iW6YVW5cE3jC4KGk=;
        b=CqnK6sY8ZLbL8yKdsuED0R/EfxJW0b1jok7DtkrKDjAl5xa7mYc6nqhhCsUE7Rz+7L
         /P6JBoPuIAa9aFIXB41VP0mQ7ADpK+ak8rCqbrFM81+o3ijSu6DErYHuVon/dCcXryIO
         dyPUTyMwD/qxLyu56uQfzZQ1nFKpG1UdHQdD0uDF5CKolFez5AIamvmmOpJ+Aq3RZDet
         hlDd6DSXCtLEBOL4eCB0MzsZtDFPlX3V/yrOoyf0I5HQn7pDpLpXDKXkkQAkStSGtIC+
         II8SzVb9LBBuU5acU1+ixNrU2rEt8SX+L5CnXkdPi/yKmtvSBMN+Mvf9Lfdio7ueO1Kv
         tVkw==
X-Gm-Message-State: APjAAAW4Sdgw81zY5E66QcxUotc/YPqltloDVgcWISPv0dI24DrTiLvh
        xqU7HcW7HV3E6uQhkTKz1h7vmA==
X-Google-Smtp-Source: APXvYqxvBN6DgHcsty886MQfm2q37TfLu/oT1dS8glPTPqBLvnlE/tkycH75zV/DtDqsb9ORoH8c/A==
X-Received: by 2002:a19:ca1b:: with SMTP id a27mr1030381lfg.93.1574112505450;
        Mon, 18 Nov 2019 13:28:25 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o10sm4169248lfn.64.2019.11.18.13.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 13:28:25 -0800 (PST)
Date:   Mon, 18 Nov 2019 13:28:11 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Linu Cherian <lcherian@marvell.com>,
        Rakesh Babu <rsaladi2@marvell.com>,
        Vamsi Attunuru <vamsi.attunuru@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH 02/15] octeontx2-af: Add support for importing firmware
 data
Message-ID: <20191118132811.091d086c@cakuba.netronome.com>
In-Reply-To: <1574007266-17123-3-git-send-email-sunil.kovvuri@gmail.com>
References: <1574007266-17123-1-git-send-email-sunil.kovvuri@gmail.com>
        <1574007266-17123-3-git-send-email-sunil.kovvuri@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 17 Nov 2019 21:44:13 +0530, sunil.kovvuri@gmail.com wrote:
> From: Linu Cherian <lcherian@marvell.com>
> 
> Firmware data is essentially a block of one time configuration data
> exported from firmware to kernel through shared memory. Base address
> of this memory is obtained through CGX firmware interface commands.
> 
> With this in place, MAC address of CGX mapped functions are inited
> from firmware data if available else they are inited with
> random MAC address.
> 
> Also
> - Added a new mbox for PF/VF to retrieve it's MAC address.
> - Now RVU MSIX vector address is also retrieved from this fwdata struct
>   instead of from CSR. Otherwise when kexec/kdump crash kernel loads
>   CSR will have a IOVA setup by primary kernel which impacts
>   RVU PF/VF's interrupts.
> 
> Signed-off-by: Linu Cherian <lcherian@marvell.com>
> Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
> Signed-off-by: Vamsi Attunuru <vamsi.attunuru@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>

Again, confusing about what this code is actually doing. Looks like
it's responding to some mailbox requests..

Please run checkpatch --strict and fix all the whitespace issues, incl.
missing spaces around comments and extra new lines.
