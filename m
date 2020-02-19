Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74FAF16429D
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 11:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgBSKxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 05:53:04 -0500
Received: from first.geanix.com ([116.203.34.67]:57048 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbgBSKxD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 05:53:03 -0500
Received: from localhost (_gateway [172.20.0.1])
        by first.geanix.com (Postfix) with ESMTPSA id 02379C002E;
        Wed, 19 Feb 2020 10:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1582109581; bh=VW+jgWITWMNA+jY6FIGR7+cpj/MuFZAzw0f/ewJNF7g=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To;
        b=hMU/sPilGZlwszhd5lSoK39aqNCiUQ79DXow8DJr08WITajb0g/jA4MXJ8abVeifh
         nkhyCkvPWZLbJJDY90uF9MfKSTj+pNUX7UpiMYigxCpwXhkq5XMo0zJCBlegR62/35
         0Z3o2VRxtOYIlqL78WGk2XMqJ8fJdJ8EqTc1i+SRWkEaggvkhdi7QtQFyFoygxthe7
         3vQaSXjJFlJOnA4tS5WXh7nXt+muMECwd5KJahXqB33z1AnaRSv+ajCI2n/nNYCe3o
         TDdekERClLYPV4o8AOAStO7eOx4l7SsDD8Q5UACLCul2XRgYQhQrXU1R1B7d7yqiyH
         rMKFfq1D7sQmQ==
From:   Esben Haabendal <esben@geanix.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch,
        michal.simek@xilinx.com, ynezz@true.cz
Subject: Re: [PATCH 0/8] net: ll_temac: Bugfixes and ethtool support
References: <20200218082607.7035-1-esben@geanix.com>
        <20200218.115014.2022578847900470441.davem@davemloft.net>
Date:   Wed, 19 Feb 2020 11:53:00 +0100
In-Reply-To: <20200218.115014.2022578847900470441.davem@davemloft.net> (David
        Miller's message of "Tue, 18 Feb 2020 11:50:14 -0800 (PST)")
Message-ID: <875zg2n90z.fsf@geanix.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.7 required=4.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=disabled
        version=3.4.3
X-Spam-Checker-Version: SpamAssassin 3.4.3 (2019-12-06) on eb9da72b0f73
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> Several errors in this submission:
>
> 1) Do not mix bug fixes and new features.  Submit the bug fixes
>    targetting 'net', and then wait for net to be merged into
>    net-next at which time you can submit the new features on
>    top.
>
> 2) As per Documentation/networking/netdev-FAQ.rst you should not
>    ever CC: stable for networking patches, we submit bug fixes to
>    stable ourselves.

Got it.  I will resend against net and net-next.

/Esben
