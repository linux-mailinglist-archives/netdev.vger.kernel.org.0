Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B20183A4FE2
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 19:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhFLRSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 13:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbhFLRSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 13:18:42 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7B9C061574
        for <netdev@vger.kernel.org>; Sat, 12 Jun 2021 10:16:42 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1623518198; bh=fSgRcLS42h33822ekbrSKFwyqBRIlbmtBJLxNeOqG9A=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=JM271BUJ7Rk6iNEUQGFMhqQu4PbHWb+uiwVD9CPrR8dxQDNbCO3HPLjfiO9ZGklJs
         w4sz7q0Dygro/JiivSBX+JV3lZHd2yx0EtFvnoM8+kq0g6C3d1TI2Ax6GVsKRUPcUJ
         TaxSxOIRuSZAt15nkoqwFIK1W+qLToamYRHGmulY3MwKH2EAi+eP4YLFWkod0NUYi6
         PLHXjV2/3MiSwTEgwE2gD+o1E5gezPaCBkA7TfWqF1zVIQUcDS0X4OMdha9tfjQHHW
         dXgKv8PD3WB5MJntUrSOni8MTxFMo4ayCVDUOt1/Xu2J/XTNG9FuPcZXuhYSQi6Mj4
         m/pNC/rO0IGqw==
To:     Tyson Moore <tyson@tyson.me>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tyson Moore <tyson@tyson.me>
Subject: Re: [PATCH] sch_cake: revise docs for RFC 8622 LE PHB support
In-Reply-To: <20210612065411.15675-1-tyson@tyson.me>
References: <20210612065411.15675-1-tyson@tyson.me>
Date:   Sat, 12 Jun 2021 19:16:37 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87a6nvt34a.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tyson Moore <tyson@tyson.me> writes:

> Commit b8392808eb3fc28e ("sch_cake: add RFC 8622 LE PHB support to CAKE
> diffserv handling") added the LE mark to the Bulk tin. Update the
> comments to reflect the change.
>
> Signed-off-by: Tyson Moore <tyson@tyson.me>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
