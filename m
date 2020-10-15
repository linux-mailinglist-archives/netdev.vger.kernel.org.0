Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F058928EB79
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 05:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729149AbgJODXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 23:23:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728937AbgJODXh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 23:23:37 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DE9B22241;
        Thu, 15 Oct 2020 03:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602732217;
        bh=oc70wBDppz8e+tXRyniXa0EcfmK9hpKco4M+8spbDog=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rrW4qxTOnHfFv9UMJida1Oa5LaGn1qLCRUEv4qYFbQGzi1o1859QrCRcRXaS11QnO
         byCOl94P7NQhHQXFMOPo+YdquO2SG9KG6JGeJCEfJYHtGq6vhtQiQQebpR7cGP1um8
         GlgjqMuimf2+uDuGb8PsarFy+Eq6bOgOJlIIbs8E=
Date:   Wed, 14 Oct 2020 20:23:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Wilder <dwilder@us.ibm.com>
Cc:     netdev@vger.kernel.org, tlfalcon@linux.ibm.com, cris.forno@ibm.com,
        pradeeps@linux.vnet.ibm.com, wilder@us.ibm.com,
        willemdebruijn.kernel@gmail.com
Subject: Re: [ PATCH v2 0/2] ibmveth gso fix.
Message-ID: <20201014202334.263764e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201013232014.26044-1-dwilder@us.ibm.com>
References: <20201013232014.26044-1-dwilder@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Oct 2020 16:20:12 -0700 David Wilder wrote:
> The ibmveth driver is a virtual Ethernet driver used on IBM pSeries systems.
> Gso packets can be sent between LPARS (virtual hosts) without segmentation,
> by flagging gso packets using one of two methods depending on the firmware
> version. Some gso packet were not correctly identified by the receiver.
> This patch-set corrects this issue.
> 
> V2:
> - Added fix tags.
> - Byteswap the constant at compilation time.
> - Updated the commit message to clarify what frame validation is performed
>   by the hypervisor.

Applied, thanks everyone!
