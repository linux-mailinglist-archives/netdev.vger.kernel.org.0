Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F73221641
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 22:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgGOUbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 16:31:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbgGOUbi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 16:31:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 205AD20657;
        Wed, 15 Jul 2020 20:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594845098;
        bh=so0mjZo5EN3Fs3hltCxxYnhvqCY33YwzANRxSMGZ/mg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K50rbXvzgwYZE8UcvdbShAbebDj0NSPl3KfvpM/rT4c8JrrZhGlhNvKHhowjNXuy3
         zclU8EQCz01RBzGp9HLHR+eKJRkzlaEBA9VQvJh8sV96ATyhXMPCy+/l5FPDvQwM5m
         GKc6Forf1P7Cox0k6xQJ+2Ppsj7VW/03/7Lgj6XQ=
Date:   Wed, 15 Jul 2020 13:31:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ian Kumlien <ian.kumlien@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org
Subject: Re: NAT performance issue 944mbit -> ~40mbit
Message-ID: <20200715133136.5f63360c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAA85sZua6Q8UR7TfCGO0bV=VU0gKtqj-8o_mqH38RpKrwYZGtg@mail.gmail.com>
References: <CAA85sZvKNXCo5bB5a6kKmsOUAiw+_daAVaSYqNW6QbSBJ0TcyQ@mail.gmail.com>
        <CAA85sZua6Q8UR7TfCGO0bV=VU0gKtqj-8o_mqH38RpKrwYZGtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 22:05:58 +0200 Ian Kumlien wrote:
> After a  lot of debugging it turns out that the bug is in igb...
> 
> driver: igb
> version: 5.6.0-k
> firmware-version:  0. 6-1
> 
> 03:00.0 Ethernet controller: Intel Corporation I211 Gigabit Network
> Connection (rev 03)

Unclear to me what you're actually reporting. Is this a regression
after a kernel upgrade? Compared to no NAT?

> It's interesting that it only seems to happen on longer links... Any clues?

Links as in with longer cables?
