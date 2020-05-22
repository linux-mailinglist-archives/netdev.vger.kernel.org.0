Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188991DEEFD
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 20:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730829AbgEVSOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 14:14:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726373AbgEVSOE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 14:14:04 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C2F9206F6;
        Fri, 22 May 2020 18:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590171243;
        bh=imsB6N/o7NnJTJe4J/e+g5f1z3cKMm9xBEk2UabmeFo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uc3P0iflpUqQ26G1o4JURfeP/QhX9bmW3XltaUq0G2WP+zGJrNCzbE+z2kNc+QAo4
         DISP7iOCASQOqiNnkAWuSWhUkP3SgPzSuxZP41fsBkSHCE/G7lKlLSRrICMOmtZRqy
         II5StZlnt4W3LjM+aDtMlw4Jg9XD0bwJMiPZLJFo=
Date:   Fri, 22 May 2020 11:14:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com
Subject: Re: [net-next 00/17][pull request] 100GbE Intel Wired LAN Driver
 Updates 2020-05-21
Message-ID: <20200522111402.20a6a3c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
References: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 May 2020 23:55:50 -0700 Jeff Kirsher wrote:
> This series contains updates to ice driver only.  Several of the changes
> are fixes, which could be backported to stable, of which, only one was
> marked for stable because of the memory leak potential.

Acked-by: Jakub Kicinski <kuba@kernel.org>
