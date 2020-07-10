Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F81621BF09
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 23:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgGJVMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 17:12:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbgGJVMB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 17:12:01 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 720442068F;
        Fri, 10 Jul 2020 21:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594415520;
        bh=dtv92RysIExNP/4vr0aXEII+j2WcLlm5yFmgM3Aqo7g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0PFcXODQshHA/N1GujomWCok/4f/VdjWapStXrzyMTj80CN3EPoeOAUMJfgBtjURm
         gtu3QT152yg5nvALVClsf0fOWG+chb7+ValzZU5cwG4U26DVeuYk7QfPPzF+xkdHPi
         HEaEp9AjTzTOPLj6crk5dPtQu4hnALpgh6osjwuw=
Date:   Fri, 10 Jul 2020 14:11:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/7] Add devlink-health support for devlink
 ports
Message-ID: <20200710141158.30e19596@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1594383913-3295-1-git-send-email-moshe@mellanox.com>
References: <1594383913-3295-1-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jul 2020 15:25:06 +0300 Moshe Shemesh wrote:
> Changes v2 -> v3:
> Added motivation to cover letter and note on uAPI.

I guess this will be a test of how many production users this API has...

Acked-by: Jakub Kicinski <kuba@kernel.org>
