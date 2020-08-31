Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE9A2581B9
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 21:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbgHaT04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 15:26:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:32962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728264AbgHaT04 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 15:26:56 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 610422083E;
        Mon, 31 Aug 2020 19:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598902015;
        bh=7+v46FcWkB3l6+tJaEJMb7GbrE8j/NhRs/73QWlH/eM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C3ZFYzp0flA07Jig05Q/weFvEZHmbmkf3SwCoiiWQKjt8rdv5pofWK/VpyfzjuPe+
         PWcj3lkdiyderuBewlEOgD6prPiiI3qcOJL7q/gCWSv4Lqc7Q2nOpdXGYgDBJMssVx
         CF5MZMIa9x6PTBLF2bfjPxktHfVag2JV0UN6+Pgc=
Date:   Mon, 31 Aug 2020 12:26:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     netdev@vger.kernel.org, drt@linux.vnet.ibm.com,
        sukadev@linux.vnet.ibm.com, ljp@linux.vnet.ibm.com,
        cforno12@linux.ibm.com
Subject: Re: [PATCH net-next 5/5] ibmvnic: Provide documentation for ACL
 sysfs files
Message-ID: <20200831122653.5bdef2f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1598893093-14280-6-git-send-email-tlfalcon@linux.ibm.com>
References: <1598893093-14280-1-git-send-email-tlfalcon@linux.ibm.com>
 <1598893093-14280-6-git-send-email-tlfalcon@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 Aug 2020 11:58:13 -0500 Thomas Falcon wrote:
> Provide documentation for ibmvnic device Access Control List
> files.

What API is used to set those parameters in the first place?

