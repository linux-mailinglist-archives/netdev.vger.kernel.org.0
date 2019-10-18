Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68D6FDCCFD
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 19:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634438AbfJRRnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 13:43:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53022 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2634394AbfJRRnH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 13:43:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=f+m4prAthfS+puv2mnsX7UxovnvVr7AlkdjyJWN6XuU=; b=swltek4wmdnOfZteRdu6q52yeS
        +cBdh1DBOkX4zAMTVdXwxOUbSWsIS+Bs4COsQJSqdWWuWbBbDLCzRa/QyqMO75MWVpcpMUvGwDGR9
        R1CDgHDhAuy0HDfXpeKhIxauiNX1xJB32O/TWUuV/a5THshYzkto5pYEkYLlnIsGemMQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iLWHI-0002S7-1k; Fri, 18 Oct 2019 19:43:04 +0200
Date:   Fri, 18 Oct 2019 19:43:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, mlxsw@mellanox.com
Subject: Re: [patch net-next] devlink: add format requirement for devlink
 param names
Message-ID: <20191018174304.GE24810@lunn.ch>
References: <20191018160726.18901-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018160726.18901-1-jiri@resnulli.us>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 06:07:26PM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Currently, the name format is not required by the code, however it is
> required during patch review. All params added until now are in-lined
> with the following format:
> 1) lowercase characters, digits and underscored are allowed
> 2) underscore is neither at the beginning nor at the end and
>    there is no more than one in a row.
> 
> Add checker to the code to require this format from drivers and warn if
> they don't follow.

Hi Jiri

Could you add a reference to where these requirements are derived
from. What can go wrong if they are ignored? I assume it is something
to do with sysfs?

      Andrew
