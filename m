Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAE42B4F7F
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 19:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388555AbgKPSaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 13:30:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:41100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388554AbgKPSaM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 13:30:12 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86EC0206F9;
        Mon, 16 Nov 2020 18:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605551411;
        bh=D8+Lewj6IDHI/5nKxpZeK0EQjFsxhCqLxFxn3pzd320=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=To9l+WqbnwWBHr/pV3r52km/e6zeQj89+007lKEzTBdoLYZIDAkBKibdpydWjSjs3
         +UKqNRszV2/yRA9Dt7XMdQAUshYVeHkBFOsOzlcrrIOqOFRB+BXlnQMvlk3+JEzz18
         ZK0CPb+bYSzQ7Tq2WgEMjRH3bwTjWql5QCv4laKo=
Date:   Mon, 16 Nov 2020 10:30:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        dnbanerg@us.ibm.com, brking@linux.vnet.ibm.com, pradeep@us.ibm.com,
        drt@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        ljp@linux.vnet.ibm.com, cforno12@linux.ibm.com,
        ricklind@linux.ibm.com
Subject: Re: [PATCH net-next 01/12] ibmvnic: Ensure that subCRQ entry reads
 are ordered
Message-ID: <20201116103009.0bfb2d09@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b0cd74bb-8f05-a201-080c-e325ae4a27b2@linux.ibm.com>
References: <1605208207-1896-1-git-send-email-tlfalcon@linux.ibm.com>
        <1605208207-1896-2-git-send-email-tlfalcon@linux.ibm.com>
        <20201114153524.1a32241f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <b0cd74bb-8f05-a201-080c-e325ae4a27b2@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 12:28:05 -0600 Thomas Falcon wrote:
> On 11/14/20 5:35 PM, Jakub Kicinski wrote:
> > On Thu, 12 Nov 2020 13:09:56 -0600 Thomas Falcon wrote:  
> >> Ensure that received Subordinate Command-Response Queue
> >> entries are properly read in order by the driver.
> >>
> >> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>  
> > Are you sure this is not a bug fix?  
> Yes, I guess it does look like a bug fix. I can omit this in v2 and 
> submit this as a stand-alone patch to net?

Yup, that's the preferred way. Thanks!
