Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 181A01080AF
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 22:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbfKWVAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 16:00:08 -0500
Received: from mail.stusta.mhn.de ([141.84.69.5]:52966 "EHLO
        mail.stusta.mhn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfKWVAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 16:00:08 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.stusta.mhn.de (Postfix) with ESMTPSA id 47L5KJ451wz4R;
        Sat, 23 Nov 2019 22:00:04 +0100 (CET)
Date:   Sat, 23 Nov 2019 23:00:01 +0200
From:   Adrian Bunk <bunk@kernel.org>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: dp83867: Why does ti,fifo-depth set only TX, and why is it
 mandatory?
Message-ID: <20191123210001.GA20458@localhost>
References: <20191114162431.GA21979@localhost>
 <190bd4d3-4bbd-3684-da31-2335b7c34c2a@ti.com>
 <20191114194715.GA29047@localhost>
 <d20a0c5a-507c-dd75-0951-e0733daf4a6e@ti.com>
 <08b61f8c-bd7b-7ea7-2e47-50ddb540d67f@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <08b61f8c-bd7b-7ea7-2e47-50ddb540d67f@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 02:24:01PM -0600, Dan Murphy wrote:
> Adrian

Hi Dan,

>...
> OK the HW team said that FIFO depth is no longer a mandatory field to be
> written for either RGMII or SGMII.
> 
> So my suggestion here is that we deprecate, but support in the driver, the
> ti-fifo-depth, and add the already documented
> 
> rx-fifo-depth and tx-fifo-depth as optional DT entries.
> 
> So I can change the driver and DT docs and test the RGMII device as above as
> long as we are in agreement

sounds good to me.

> Dan

Thanks
Adrian
