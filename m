Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 468BF25815A
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 20:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbgHaSuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 14:50:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727933AbgHaSuc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 14:50:32 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B279E206FA;
        Mon, 31 Aug 2020 18:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598899831;
        bh=t5UdsuFt1PJ4eDte+j2gA/HnPPvfps1XNEGyBR6OXEg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j1+qLpAOBIheJoR3Mrt/lMgFOE1Ab1UWwlYW1uzVig9wsEbrz0NawTYYaJCOIEz0M
         CLi/WM1yYoDiWUQ5/hVyx6QvxH7ldo/srVbnmX07FuB35n0y5kQnYlV1pOHkYzbeud
         OJBusX5bo+Vnf/6ODyDFnhsjGrz8FuV9X4HpRlOU=
Date:   Mon, 31 Aug 2020 11:50:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] sfc: clean up some W=1 build warnings
Message-ID: <20200831115029.5236309c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <57fd4501-4f13-37ee-d7f0-cda8b369bba6@solarflare.com>
References: <57fd4501-4f13-37ee-d7f0-cda8b369bba6@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Aug 2020 18:48:25 +0100 Edward Cree wrote:
> A collection of minor fixes to issues flagged up by W=3D1.
> After this series, the only remaining warnings in the sfc driver are
>  some 'member missing in kerneldoc' warnings from ptp.c.
> Tested by building on x86_64 and running 'ethtool -p' on an EF10 NIC;
>  there was no error, but I couldn't observe the actual LED as I'm
>  working remotely.

LGTM, although borderline net if you ask me.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

> [ Incidentally, ethtool_phys_id()'s behaviour on an error return
>   looks strange =E2=80=94 if I'm reading it right, it will break out of t=
he
>   inner loop but not the outer one, and eventually return the rc
>   from the last run of the inner loop.  Is this intended? ]

I think you're right. Care to fix?
