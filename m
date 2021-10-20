Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47988434FDF
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 18:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbhJTQOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 12:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbhJTQOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 12:14:04 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE6EC061749;
        Wed, 20 Oct 2021 09:11:49 -0700 (PDT)
Received: from miraculix.mork.no ([IPv6:2a01:799:95d:2d0a:8f32:db9:5b33:3a2e])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 19KGBSIO3018628
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 20 Oct 2021 18:11:29 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1634746289; bh=jOOKfjFNnBsWJOZ7VQu8deXbka0Jh+Uk8RaP20SvTZk=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=X6ceJEXYHZJG6V8wvZ9TTk8uSwR6eLA6DQQGwWii3C9gyp8vLoU+m7gKurB0N3cb3
         lMYBTLE3VplkGS0sM8hKw7KDo2cyfjNNW0mqBbRRNK0XjyPXVnBQVoTj3X7/gGxd5h
         d3JQ1KQEmVpeAeSljqEcY2siCU4pO95pFu3MBOnk=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@mork.no>)
        id 1mdEBX-00067j-9r; Wed, 20 Oct 2021 18:11:23 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 03/12] net: qmi_wwan: use dev_addr_mod()
Organization: m
References: <20211020155617.1721694-1-kuba@kernel.org>
        <20211020155617.1721694-4-kuba@kernel.org>
Date:   Wed, 20 Oct 2021 18:11:23 +0200
In-Reply-To: <20211020155617.1721694-4-kuba@kernel.org> (Jakub Kicinski's
        message of "Wed, 20 Oct 2021 08:56:08 -0700")
Message-ID: <878ryn65hw.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.3 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
