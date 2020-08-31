Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48602583D6
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 00:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730377AbgHaWAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 18:00:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbgHaWAw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 18:00:52 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA8CE2065F;
        Mon, 31 Aug 2020 22:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598911251;
        bh=ojjTwHv3MiRwbJ3Sa5W0PmNhhgNJBPc8QgENakrIiYA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PAtePQnJcVy4H6LH+ijGAj58WQqSFZAkEVrckJgpW9Rc3syiSW+2se/oz7jKHmMbq
         B6r7c1WHsBruhpEBURQtCVgCowg/W44JnUs/PY0/qExoF9b8U5Y5LtYwaiiuoPMXVp
         Os/NUSVqNAJLH+Cck7hxxQq89crA6NfWI18o2ZRY=
Date:   Mon, 31 Aug 2020 15:00:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     netdev@vger.kernel.org, drt@linux.vnet.ibm.com,
        sukadev@linux.vnet.ibm.com, ljp@linux.vnet.ibm.com,
        cforno12@linux.ibm.com
Subject: Re: [PATCH net-next 5/5] ibmvnic: Provide documentation for ACL
 sysfs files
Message-ID: <20200831150050.3cadde6c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <fa1d1efb-d799-a1e1-5e1e-8795d5d6cda7@linux.ibm.com>
References: <1598893093-14280-1-git-send-email-tlfalcon@linux.ibm.com>
        <1598893093-14280-6-git-send-email-tlfalcon@linux.ibm.com>
        <20200831122653.5bdef2f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d88edd04-458e-b5a5-4cc0-e91c4931d1af@linux.ibm.com>
        <20200831131158.03ac2d86@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <fa1d1efb-d799-a1e1-5e1e-8795d5d6cda7@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 Aug 2020 16:44:06 -0500 Thomas Falcon wrote:
> On 8/31/20 3:11 PM, Jakub Kicinski wrote:
> > This seems similar to normal SR-IOV operation, but I've not heard of
> > use cases for them VM to know what its pvid is. Could you elaborate?  
> It's provided for informational purposes.

Seems like an information leak :S and since it's equivalent to the
standard SR-IOV functionality - we'd strongly prefer a common
interface for all use cases. sysfs won't be it. Jiri & Mellanox had 
been working on something in devlink for quite some time.
