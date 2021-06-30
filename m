Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99DD33B7D56
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 08:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbhF3GXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 02:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbhF3GXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 02:23:11 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6767C061766
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 23:20:42 -0700 (PDT)
Received: from miraculix.mork.no ([IPv6:2a01:799:95d:4a0a:c6de:35d9:792f:bbcf])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 15U6KRsK029132
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 30 Jun 2021 08:20:30 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1625034030; bh=aiV7FZK5oej1+IjMd2NoWtNj9THDP7vYJxGzVIeSvbU=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=hRq32yeVlTX/tE25E1DBGNRCP5I/d8gcwuZgdSrwcDZHYjCSLHcYKVre9DMLDpwX9
         1Wg1wJ14QShJSYoLOJCthaHE17fwvCZpG1ulqO57fNt1ISyJeQg/XbodUj6nXuRkH4
         0h4ueUEWB7y1xJFXp7TaNPb2s/8H+mhpkZPU4y+c=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@mork.no>)
        id 1lyTa8-0003rN-E9; Wed, 30 Jun 2021 08:20:20 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Marco De Marco <marco.demarco@posteo.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] net: Add support for u-blox LARA-R6 modules family
Organization: m
References: <4911218.dTlGXAFRqV@mars> <5473473.x7jBqtuPIS@mars>
Date:   Wed, 30 Jun 2021 08:20:20 +0200
In-Reply-To: <5473473.x7jBqtuPIS@mars> (Marco De Marco's message of "Tue, 29
        Jun 2021 15:29:17 +0000")
Message-ID: <87eecjj2l7.fsf@miraculix.mork.no>
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

> Support for u-blox LARA-R6 modules family - QMI wan interface.
>
> Signed-off-by: Marco De Marco <marco.demarco@posteo.net>

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
