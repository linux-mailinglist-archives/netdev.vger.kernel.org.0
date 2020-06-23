Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E98206899
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 01:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387627AbgFWXpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 19:45:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387532AbgFWXpb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 19:45:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72BC620738;
        Tue, 23 Jun 2020 23:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592955930;
        bh=arfSyGrf9M0Gj6YAurmZNxbZgbhxBVkQKiU4zlEtUrQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wzwMxLIsqChE1apbAPo2BtBEcjsgH6ghU49pFkifxnJdeMnAvUadwIulWPHZzuVA+
         rtd/+0+kO0uYoLcis0ivax02R7s10TCCKd5WkXIsWJ+8P0mBMlTyxOOAJByNzK2IlH
         R7ZY4wdzHQQtzSDiGTalr208ZrFPVJ+Lqh/YAIYQ=
Date:   Tue, 23 Jun 2020 16:45:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net 0/4] bnxt_en: Bug fixes.
Message-ID: <20200623164528.4ee58147@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1592953298-20858-1-git-send-email-michael.chan@broadcom.com>
References: <1592953298-20858-1-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jun 2020 19:01:34 -0400 Michael Chan wrote:
> The first patch stores the firmware version code which is needed by the
> next 2 patches to determine some worarounds based on the firmware version.
> The workarounds are to disable legacy TX push mode and to clear the
> hardware statistics during ifdown.  The last patch checks that it is
> a PF before reading the VPD.
> 
> Please also queue these for -stable.  Thanks.

FWIW looks good to me:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
