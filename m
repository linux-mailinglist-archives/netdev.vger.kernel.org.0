Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2985BD1EBB
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 05:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731134AbfJJDB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 23:01:27 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38292 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbfJJDB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 23:01:26 -0400
Received: by mail-pg1-f196.google.com with SMTP id x10so2697838pgi.5
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 20:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=v6u1nm7ngSdTRUQiclEkIH6dgRDZsgNswCXmJQZSsgM=;
        b=QAF/Os5xoueQ8rdoO6FNDTWRqktCXRM40BzdZNlRoF7TF82l202ByA5b3vOwt2Yaz8
         dR12DG6ohybXtbC6IOCBXL86T0HvWO+Md4YgAEuI4RP8gitSPotMX33jFpkr3dDs0fC/
         HUXIILxFzwvx8GGYHFLMCZM+qIrFU4FVLvA/BfSNHi3docXbFDr8MV6G5Q8gUzJUW50y
         v+rawkfXqsIeAiGAKSF5TDK1oSQ3LZzlQE9s6cAr7DMMKCJATWrlIuC5CLtwSkdzr38R
         dgQcH/pz2xdVL117h82Jb9DUjNbQEXd+8Kt/lB1wMvcbd/Ldwx8FP/mD+25xA0V6sfaK
         92hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=v6u1nm7ngSdTRUQiclEkIH6dgRDZsgNswCXmJQZSsgM=;
        b=D0RZWLlvWZeQs1BaMvyNXvBXmUaXSbGPmgir01ehMoxy8VEVSb2O2W63jdGfzNeBfK
         wyXkWtCo+CdYfeEcNULPk+T735J+7qjRkZNtvld/UaonrtLJ9JKNnuhrUx7FNkGdG6lF
         Tk6raiUlZsIKC6uM3DIPVndQTthw+gov5UuEtOt7klWyMbEtyNQ5YuPQJENiv9lWE1JX
         ogxK3kcskX0TSnMFjdWyXwW9Ik0uJ792ZXO5CoPdPhFyG84ZT6gDJABlZuTIoStRiR+w
         v2xnXzwmiSdW2B1Z+AO7sbS4yexbYCzsDI/PQAfz9W/ApVNi1Fo/ZP4uxQsi2vnYSscc
         nttA==
X-Gm-Message-State: APjAAAUB2VWE4TzVAYXf2O03IQR2cGYnSCOT9MzVTpfgnHN7RQ2xNApZ
        twG4QhGQyAIKeROvg+ac3y9n9A==
X-Google-Smtp-Source: APXvYqztCepxhPI8wVLqUFSvMSUJ3Xg7tfFGNsf3EDq2abdkO61i+0q0CH1onsG3+oafcaYMDI+q9A==
X-Received: by 2002:aa7:821a:: with SMTP id k26mr7682485pfi.184.1570676486256;
        Wed, 09 Oct 2019 20:01:26 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id v3sm3574007pfn.18.2019.10.09.20.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 20:01:26 -0700 (PDT)
Date:   Wed, 9 Oct 2019 20:01:12 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/1] net: usb: qmi_wwan: add Telit 0x1050 composition
Message-ID: <20191009200112.78ba1ba7@cakuba.netronome.com>
In-Reply-To: <20191009090718.12879-1-dnlplm@gmail.com>
References: <20191009090718.12879-1-dnlplm@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Oct 2019 11:07:18 +0200, Daniele Palmas wrote:
> This patch adds support for Telit FN980 0x1050 composition
> 
> 0x1050: tty, adb, rmnet, tty, tty, tty, tty
> 
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>

Applied, thanks!
