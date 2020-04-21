Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39861B2E6D
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 19:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729170AbgDURjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 13:39:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbgDURja (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 13:39:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28F27206F4;
        Tue, 21 Apr 2020 17:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587490770;
        bh=PK1TPX9OIyBXHzPOzlMdw1D74rXZ/c3gqUO83QVwSbg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wtLpW4nJ8drmoq26Nx57MFwvp9g4t0GIAaMkmIooIjQb0qY+yCix7W6kwmZa1ZxCp
         2fiO55W9ncf7erXkNcYPwdsr5dV/AyNdW8YNWoIm7EQoeZFGFy9dK/GechFE9341gK
         V/X9psihIFX0G+YHH9l0/qWZWIC7W2bySG8OG5tg=
Date:   Tue, 21 Apr 2020 10:39:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Andre Guedes <andre.guedes@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: Re: [net-next 02/13] igc: Use netdev log helpers in igc_main.c
Message-ID: <20200421103928.45006d85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200420234313.2184282-3-jeffrey.t.kirsher@intel.com>
References: <20200420234313.2184282-1-jeffrey.t.kirsher@intel.com>
        <20200420234313.2184282-3-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Apr 2020 16:43:02 -0700 Jeff Kirsher wrote:
> It also
> takes this opportunity to improve some messages and remove the '\n'
> character at the end of messages since it is automatically added to by
> netdev_* log helpers.

Can you point me to the place that's done?
