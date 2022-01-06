Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954B5486B4C
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 21:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbiAFUi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 15:38:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232673AbiAFUi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 15:38:57 -0500
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7077AC061245
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 12:38:57 -0800 (PST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1641501534; bh=BXUnuZTS2ghIWYw4UJ1Cy5FJEUoINU/ECpHZ4syUGpI=;
        h=From:To:Subject:In-Reply-To:References:Date:From;
        b=X9n8VFx3zl3YlOVRoKOdPPMNJTwmoaP2XdyTf/YADdfKesjXBX8JAwfr/nbLwJQjV
         NNtAJNgK3U5Cp94o4B08UFEzZNnoyfBjSG2wovl1X7vwiVolFvYQL8GVHMtE3T02vQ
         NwSq6ejiA39bc9zDpB0G9jLzn6t/1b6bxnWjdrqyhluyZT9siLWEaSLNA2jIt+qz0N
         2P/EqoMdgnIOo2VyiAiICQlL0Vte3QH4LpeXP/UzVOhUV61+taUiUe1nX5PocSvV/8
         LKCoNlE++jbxC97tzORlAPA0wQ3Wl/OiSKt0FpLguFUGyCFcQ5DA2LoM5iFpt/v7Zf
         fgwTDpiBLR0yQ==
To:     Kevin Bracey <kevin@bracey.fi>, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] q_cake: allow changing to diffserv3
In-Reply-To: <20220106111604.2919263-1-kevin@bracey.fi>
References: <20220106111604.2919263-1-kevin@bracey.fi>
Date:   Thu, 06 Jan 2022 21:38:54 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87k0fca9b5.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kevin Bracey <kevin@bracey.fi> writes:

> A diffserv3 option (enum value 0) was never sent to the kernel, so it
> was not possible to use "tc qdisc change" to select it.
>
> This also meant that were also relying on the kernel's default being
> diffserv3 when adding. If the default were to change, we wouldn't have
> been able to request diffserv3 explicitly.
>
> Signed-off-by: Kevin Bracey <kevin@bracey.fi>

Yeah, that should probably be fixed; thanks!

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
