Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C5D43CD54
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 17:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234880AbhJ0PTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 11:19:12 -0400
Received: from vern.gendns.com ([98.142.107.122]:55072 "EHLO vern.gendns.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233168AbhJ0PTL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 11:19:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=lechnology.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ocflwe/8dIzhHJ66ro8h4DqJvIY+LMP8z6/EwT6ny1Q=; b=vlvZWqHnIGZPYwXTrTLgOKBCTC
        oTFCmz6RVudDnW3RijY6aZarakwlOnDbiaGVlMJeTEZwFbAPU788Gw27XGPdFF0+CQmykVLL3nsFh
        aLNILuoDMMb6UOKkv4i9tYZNweulg3NSR7oU2I6Vge6ftQPiEHEpD7xMZJt0/EenyA8NbZXEzMg+O
        yUTpFRse93lXyauXmgJ9wLkmAfp43V61Fb++EFJyXk3ZSqm+NZvRzOxdI6X4HZDEPhiz6docNbZNb
        Smva89wehe8YCThymMANzHqZPwzYuh+1y1SSQ3yT7oswhoa6geKeZHd4iHBkq1Xl5iY0WRSudt+Ps
        xoT+ROmw==;
Received: from 108-198-5-147.lightspeed.okcbok.sbcglobal.net ([108.198.5.147]:42536 helo=[192.168.0.134])
        by vern.gendns.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <david@lechnology.com>)
        id 1mfkfM-00071R-O1; Wed, 27 Oct 2021 11:16:45 -0400
Subject: Re: [PATCH] dt-bindings: net: ti,bluetooth: Document default
 max-speed
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org
References: <0c6a08c714aeb6dd96b5a54a45b0b5b1cfb49ad1.1635338283.git.geert+renesas@glider.be>
From:   David Lechner <david@lechnology.com>
Message-ID: <43edc394-1eec-f9dd-4cbe-ade830511cbb@lechnology.com>
Date:   Wed, 27 Oct 2021 10:16:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <0c6a08c714aeb6dd96b5a54a45b0b5b1cfb49ad1.1635338283.git.geert+renesas@glider.be>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - vern.gendns.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lechnology.com
X-Get-Message-Sender-Via: vern.gendns.com: authenticated_id: davidmain+lechnology.com/only user confirmed/virtual account not confirmed
X-Authenticated-Sender: vern.gendns.com: davidmain@lechnology.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/27/21 7:38 AM, Geert Uytterhoeven wrote:
> Document the default value of max-speed, as used by
> linux/drivers/bluetooth/hci_ll.c.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---

Acked-by: David Lechner <david@lechnology.com>

