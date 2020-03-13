Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA8A184E95
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 19:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgCMS2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 14:28:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43806 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbgCMS2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 14:28:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BCF36159D45DF;
        Fri, 13 Mar 2020 11:28:06 -0700 (PDT)
Date:   Fri, 13 Mar 2020 11:28:06 -0700 (PDT)
Message-Id: <20200313.112806.745559086761683359.davem@davemloft.net>
To:     stefan@datenfreihafen.org
Cc:     linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        netdev@vger.kernel.org
Subject: Re: pull-request: ieee802154-next 2020-03-13
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200313133621.11374-1-stefan@datenfreihafen.org>
References: <20200313133621.11374-1-stefan@datenfreihafen.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 13 Mar 2020 11:28:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Schmidt <stefan@datenfreihafen.org>
Date: Fri, 13 Mar 2020 14:36:21 +0100

> An update from ieee802154 for *net-next*
> 
> Two small patches with updates targeting teh whole tree.
> Sergin does update SPI drivers to the new transfer delay handling
> and Gustavo did one of his zero-length array replacement patches.
> 
> Please pull, or let me know if there are any problems.

Pulled, thanks Stefan.
