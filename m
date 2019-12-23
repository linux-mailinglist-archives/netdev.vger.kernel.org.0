Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4355F1294E8
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 12:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbfLWLQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 06:16:53 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38088 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbfLWLQx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Dec 2019 06:16:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JitMHg8UEDgb7OXVJB+ymCq8U9B86eYc6YAiqKoW3Vs=; b=jKHL+QjsPsQaOY2mjg6depThII
        4akuDOsao1R5VzZhSXK7Z9T8c4tCYi0gZuAwuxG3n+5xFmZmeHOVgRpxn3ywh7rRZhfB/5mUazc9T
        1NNN9R6zmpNxq/ibpGqjEIU3iCTOVt6kQR7mtgPUo/5FChHrNL6ihh0ek/KdzG3ja0Ow=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ijLhh-00029X-VY; Mon, 23 Dec 2019 12:16:49 +0100
Date:   Mon, 23 Dec 2019 12:16:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [RFC 0/3] VLANs, DSA switches and multiple bridges
Message-ID: <20191223111649.GJ32356@lunn.ch>
References: <20191222192235.GK25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191222192235.GK25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 22, 2019 at 07:22:35PM +0000, Russell King - ARM Linux admin wrote:
> Hi,
> 
> I've been trying to configure DSA for VLANs and not having much success.

Hi Russell

I'm hoping Vivien will review these patches. He understands all the
VLAN things better than i.

     Andrew
