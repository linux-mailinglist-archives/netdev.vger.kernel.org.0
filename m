Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006A825824E
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 22:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgHaUMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 16:12:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726939AbgHaUMA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 16:12:00 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53E982078B;
        Mon, 31 Aug 2020 20:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598904720;
        bh=oy3YoQA/q5rG/lJeUPWdnZoC+vRpqJ0THREllnTpeJc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M7CzP4e2dxkVQhfmX+fe+2nkvGWtps5Fvxwud9NoNSYInAoCcZbZ4UKL+fMRZ6F3r
         0iIzcHmrY2WOWMYBmcX7QlgHR15GtVsyTtpG7T4obDyc6GM88SlRB4eFkgmtLdhe93
         rloj2E2LkF3FzeKA6vuzo6wYoYZ+3mmPCMzUOItE=
Date:   Mon, 31 Aug 2020 13:11:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     netdev@vger.kernel.org, drt@linux.vnet.ibm.com,
        sukadev@linux.vnet.ibm.com, ljp@linux.vnet.ibm.com,
        cforno12@linux.ibm.com
Subject: Re: [PATCH net-next 5/5] ibmvnic: Provide documentation for ACL
 sysfs files
Message-ID: <20200831131158.03ac2d86@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d88edd04-458e-b5a5-4cc0-e91c4931d1af@linux.ibm.com>
References: <1598893093-14280-1-git-send-email-tlfalcon@linux.ibm.com>
        <1598893093-14280-6-git-send-email-tlfalcon@linux.ibm.com>
        <20200831122653.5bdef2f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d88edd04-458e-b5a5-4cc0-e91c4931d1af@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 Aug 2020 14:54:06 -0500 Thomas Falcon wrote:
> On 8/31/20 2:26 PM, Jakub Kicinski wrote:
> > On Mon, 31 Aug 2020 11:58:13 -0500 Thomas Falcon wrote:  
> >> Provide documentation for ibmvnic device Access Control List
> >> files.  
> > What API is used to set those parameters in the first place?
> >  
> These parameters are specified in the system's IBM Hardware Management 
> Console (HMC) when the VNIC device is create.

The new attributes are visible in the "guest" OS, correct?

This seems similar to normal SR-IOV operation, but I've not heard of
use cases for them VM to know what its pvid is. Could you elaborate?
