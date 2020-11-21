Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2652BC2A6
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 00:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgKUXgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 18:36:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:56748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726227AbgKUXgj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 18:36:39 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53853208C3;
        Sat, 21 Nov 2020 23:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606001798;
        bh=0s3sfuZ6tTFYjmsX8XbMboW7AB2YD+Gh+vUP/pX218c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZLLQxzRzY0EOvnetCJtTytoHfJKjDWdmFiVpRJ4fj2N8jBYCqe7DRyPZaB+oQGfBi
         SOhli6R4LTh51k1BLi9cT1MH4mRSGNizzu5bo8GpiK2qq843qTKiOWdilPeGaH3ugj
         Hohgt0YebfLWVnyh3Y2uy9QzB883yAsj6TZjsn4g=
Date:   Sat, 21 Nov 2020 15:36:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org, sukadev@linux.ibm.com, drt@linux.ibm.com
Subject: Re: [PATCH net 02/15] ibmvnic: process HMC disable command
Message-ID: <20201121153637.17a91ac4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201120224049.46933-3-ljp@linux.ibm.com>
References: <20201120224049.46933-1-ljp@linux.ibm.com>
        <20201120224049.46933-3-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 16:40:36 -0600 Lijun Pan wrote:
> From: Dany Madden <drt@linux.ibm.com>
> 
> Currently ibmvnic does not support the disable vnic command from the
> Hardware Management Console. This patch enables ibmvnic to process
> CRQ message 0x07, disable vnic adapter.

What user-visible problem does this one solve?
