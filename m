Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B863B69C2
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 22:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234521AbhF1Uko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 16:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbhF1Ukm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 16:40:42 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5935EC061574;
        Mon, 28 Jun 2021 13:38:15 -0700 (PDT)
Received: from miraculix.mork.no ([IPv6:2a01:799:95d:4a0a:c6de:35d9:792f:bbcf])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 15SKbxHx013070
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Mon, 28 Jun 2021 22:38:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1624912681; bh=Ytrhd6z8WEzd0MS5LyinrOj2ijImEHc564T7sYUloiM=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=n710+EWWXR1kfZWDKk8Rv5qwoHNBw2lbjLS8S1s49YRUZ1YZVoH+WxEgTG8LIf++i
         A7HmSGcuRkYtpsiJ9Lhdt/6iuo/2NsgDthNAzcmIO5sxFuG0SYLelvel0linE5Ht7j
         HUHd3araClX5sM4ZnHb3s6NmFoIWv1FVo5zAIkb4=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@mork.no>)
        id 1lxy0w-00017T-FZ; Mon, 28 Jun 2021 22:37:54 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Marco De Marco <marco.demarco@posteo.net>
Cc:     johan@kernel.org, linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] usb: net: Add support for u-blox LARA-R6 modules family
Organization: m
References: <4911218.dTlGXAFRqV@mars>
Date:   Mon, 28 Jun 2021 22:37:54 +0200
In-Reply-To: <4911218.dTlGXAFRqV@mars> (Marco De Marco's message of "Mon, 28
        Jun 2021 14:35:56 +0000")
Message-ID: <87v95xiv31.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.2 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marco De Marco <marco.demarco@posteo.net> writes:

> Support for u-blox LARA-R6 modules family.

Thanks.  But please split this in separate patches for net and usb.
Different subsystems with different trees and maintainers.

And while you are at it:  Use lower case hex digits.  In general:
Always try to follow the style of nearby code.


Bj=C3=B8rn
