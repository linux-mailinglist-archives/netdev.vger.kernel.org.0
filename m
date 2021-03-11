Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E49337F1E
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 21:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbhCKUfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 15:35:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:51290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229555AbhCKUfM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 15:35:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59A7C64F87;
        Thu, 11 Mar 2021 20:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615494911;
        bh=fO55sTVm+2BWuAV/wCsxJ4NmcsOMOJydW1+vFwSMUwI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Joy4qO6AQwvtNPoxtAz+rKz1mdprhTG01jq/Suo/rno8BOb5M4MoSrsqJRdXkFcqt
         7Ksuvqn2Ku4nbZLY4SVfPzGOtwWGi4tV4NjCj58Cf/az+E0vGwATEgdVDWlLXyn2Qs
         Y4IRbafGdy9QLJxiInJH1pDvALNhI8rWoTafZgeN98+phZasS212ccBfiIB5ZL9Izw
         CRsSLlS8KsEqBdo3rv08VRgLdXoG4kzXI9OMZdsiCylj+ThMCoX79m94QURg94uoiW
         uuLWoPzp2lw8g17LDE+4iDf7eiLQiZ/T5tHmat+7+VFS0X7T5Oga9rCdDcS6HDF7+O
         K0yzRYzSo5uyg==
Date:   Thu, 11 Mar 2021 12:35:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kurt Kanzenbach <kurt@kmk-computers.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/6] net: dsa: hellcreek: Report RAM usage
Message-ID: <20210311123510.0d8217ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210311175344.3084-2-kurt@kmk-computers.de>
References: <20210311175344.3084-1-kurt@kmk-computers.de>
        <20210311175344.3084-2-kurt@kmk-computers.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Mar 2021 18:53:39 +0100 Kurt Kanzenbach wrote:
> Report the RAM usage via devlink. This is a useful debug feature. The actual
> size depends on the used Hellcreek version:
> 
> |root@tsn:~# devlink resource show platform/ff240000.switch
> |platform/ff240000.switch:
> |  name VLAN size 4096 occ 3 unit entry dpipe_tables none
> |  name FDB size 256 occ 6 unit entry dpipe_tables none
> |  name RAM size 320 occ 14 unit entry dpipe_tables none

What is stored in this RAM? 
