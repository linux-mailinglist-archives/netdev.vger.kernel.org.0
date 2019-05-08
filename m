Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 826FF182B6
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 01:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbfEHXdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 19:33:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53826 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbfEHXdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 19:33:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 708A0146EDF8F;
        Wed,  8 May 2019 16:33:08 -0700 (PDT)
Date:   Wed, 08 May 2019 16:33:08 -0700 (PDT)
Message-Id: <20190508.163308.1120079651482055857.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     jiri@resnulli.us, netdev@vger.kernel.org,
        oss-drivers@netronome.com, pieter.jansenvanvuuren@netronome.com
Subject: Re: [PATCH net] nfp: reintroduce ndo_get_port_parent_id for
 representor ports
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190508225256.25846-1-jakub.kicinski@netronome.com>
References: <20190508225256.25846-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 May 2019 16:33:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Wed,  8 May 2019 15:52:56 -0700

> From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
> 
> NFP does not register devlink ports for representors (without
> the "devlink: expose PF and VF representors as ports" series
> there are no port flavours to expose them as).
> 
> Commit c25f08ac65e4 ("nfp: remove ndo_get_port_parent_id implementation")
> went to far in removing ndo_get_port_parent_id for representors.
> This causes redirection offloads to fail, and switch_id attribute
> missing.
> 
> Reintroduce the ndo_get_port_parent_id callback for representor ports.
> 
> Fixes: c25f08ac65e4 ("nfp: remove ndo_get_port_parent_id implementation")
> Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Applied.
