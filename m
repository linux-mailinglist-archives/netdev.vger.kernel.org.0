Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50E89449FA
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfFMRyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:54:46 -0400
Received: from canardo.mork.no ([148.122.252.1]:51843 "EHLO canardo.mork.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbfFMRyp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 13:54:45 -0400
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id x5DHsfCD027126
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 13 Jun 2019 19:54:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1560448481; bh=n+tlJw6+AprkV1uA2FklHz0gOb5nguzYBW/pgXvgx/Q=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=GUrFXVWvm07ukdt5dTIZVGvrIW6bBmbOjdBDyjB/eMiDYkSOUf10pxrHoGAUhiUtK
         XBRsDon//1NmCUsTA5+QgJUEzDKMur2EQmWL/axqyPvusFm1+SNln40Bq9gGD/PZHt
         nRP4bV3zGQypemZUnlDZ3wIlzHYq/yybJqVGGC9Q=
Received: from bjorn by miraculix.mork.no with local (Exim 4.89)
        (envelope-from <bjorn@mork.no>)
        id 1hbTvs-0000Al-To; Thu, 13 Jun 2019 19:54:40 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Reinhard Speyerer <rspmn@arcor.de>
Cc:     Daniele Palmas <dnlplm@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] qmi_wwan: fix QMAP handling
Organization: m
References: <cover.1560287477.git.rspmn@arcor.de>
Date:   Thu, 13 Jun 2019 19:54:40 +0200
In-Reply-To: <cover.1560287477.git.rspmn@arcor.de> (Reinhard Speyerer's
        message of "Wed, 12 Jun 2019 19:01:44 +0200")
Message-ID: <874l4t8j6n.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.100.3 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reinhard Speyerer <rspmn@arcor.de> writes:

> This series addresses the following issues observed when using the
> QMAP support of the qmi_wwan driver:

Really nice work!  Thanks.

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
