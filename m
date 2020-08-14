Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE5D244F84
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 23:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbgHNVU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 17:20:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727838AbgHNVUZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 17:20:25 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A33C206C0;
        Fri, 14 Aug 2020 21:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597440025;
        bh=ygwQZ+9SrCVVdohMi2y3Yoz5UyhdL/6DIEfS7cn32Ew=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RhoyeTdDNvVrkZ/5Ua66jUUZ8KZKfGLIzPYxvlVjto9sPCRQX41/u9E1fETCC6sth
         4tYy/DKvSQO4M/61ib6vWjOeyINu0wmE+us0LgTtk52j4MUdiD2hq/OFoF6o1LM9Zw
         qqTaXJF+1T37XwEAvzdzo5wTZpGGQZp/g06X86p4=
Date:   Fri, 14 Aug 2020 14:20:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: Re: [net 3/3] i40e: Fix crash during removing i40e driver
Message-ID: <20200814142023.504cc328@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200814203643.186034-4-anthony.l.nguyen@intel.com>
References: <20200814203643.186034-1-anthony.l.nguyen@intel.com>
        <20200814203643.186034-4-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Aug 2020 13:36:43 -0700 Tony Nguyen wrote:
> Fixes: 4b8164467b85 ("Add common function for finding VSI by type")

Fixes tag: Fixes: 4b8164467b85 ("Add common function for finding VSI by type")
Has these problem(s):
	- Subject does not match target commit subject
	  Just use
		git log -1 --format='Fixes: %h ("%s")'
