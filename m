Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1DCD423AC3
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 11:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237875AbhJFJq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 05:46:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237929AbhJFJqw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 05:46:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACEE761042;
        Wed,  6 Oct 2021 09:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633513501;
        bh=XD9jOi/4VXMDIlLVjQpA9rBxSsl9vrWX6SL0fFsrimk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f5/e1PaBSFJ6bbwUFgM8hgK1a0z4ca6OLuVQ+VjHBjb+zdgC1t4QMeemMNBBq6SQW
         cCT9RDBkrcFrucnBIJE+9B239sC8mmmdrS9u43B7R8LPh6p4jtyff0midv9pQTRm0D
         ePDwpFBZFUBk+fNRSBkCi37DRZc9L4yFZ9MRpkFgsf+W95/aAujDqIwSuKxUP/bhLt
         BLSgVacFmhKyyLa8+p83GobctmW3AKNh7/dETSIxrgIZSHTbkhsruM0xhsBWi/NecT
         fwoamBN/zDmtyaqJP6YWotpBG7JOTyd51VqUAXGBKSatDvt8N4JnQvMMTfZK4dzRrs
         zFVXcukAOKF7w==
From:   Antoine Tenart <atenart@kernel.org>
To:     jiri@nvidia.com, stephen@networkplumber.org, dsahern@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH iproute2-next 2/3] man: devlink-port: fix style
Date:   Wed,  6 Oct 2021 11:44:54 +0200
Message-Id: <20211006094455.138504-2-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211006094455.138504-1-atenart@kernel.org>
References: <20211006094455.138504-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Values should be .I, square brackets should be used for optional values,
curly brackets for lists. Follow this in the devlink-port man page.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 man/man8/devlink-port.8 | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/man/man8/devlink-port.8 b/man/man8/devlink-port.8
index 4d2ff5d87144..e5686deae573 100644
--- a/man/man8/devlink-port.8
+++ b/man/man8/devlink-port.8
@@ -45,16 +45,16 @@ devlink-port \- devlink port configuration
 
 .ti -8
 .BI "devlink port add"
-.RB "["
+.RB "{"
 .IR "DEV | DEV/PORT_INDEX"
-.RB "] "
+.RB "} "
 .RB "[ " flavour
 .IR FLAVOUR " ]"
 .RB "[ " pcipf
 .IR PFNUMBER " ]"
 .br
-.RB "{ " sfnum
-.IR SFNUMBER " }"
+.RB "[ " sfnum
+.IR SFNUMBER " ]"
 .br
 .RB "[ " controller
 .IR CNUM " ]"
@@ -102,7 +102,7 @@ devlink-port \- devlink port configuration
 .SS devlink port set - change devlink port attributes
 
 .PP
-.B "DEV/PORT_INDEX"
+.I "DEV/PORT_INDEX"
 - specifies the devlink port to operate on.
 
 .in +4
@@ -126,7 +126,7 @@ set port type
 .SS devlink port split - split devlink port into more
 
 .PP
-.B "DEV/PORT_INDEX"
+.I "DEV/PORT_INDEX"
 - specifies the devlink port to operate on.
 
 .TP
@@ -137,7 +137,7 @@ number of ports to split to.
 Could be performed on any split port of the same split group.
 
 .PP
-.B "DEV/PORT_INDEX"
+.I "DEV/PORT_INDEX"
 - specifies the devlink port to operate on.
 
 .SS devlink port show - display devlink port attributes
@@ -154,11 +154,11 @@ Is an alias for
 .ti -8
 .SS devlink port add - add a devlink port
 .PP
-.B "DEV"
+.I "DEV"
 - specifies the devlink device to operate on. or
 
 .PP
-.B "DEV/PORT_INDEX"
+.I "DEV/PORT_INDEX"
 - specifies the devlink port index to use for the requested new port.
 This is optional. When omitted, driver allocates unique port index.
 
@@ -173,17 +173,17 @@ set port flavour
 - PCI SF port
 
 .TP
-.BR pfnum " { " pfnumber " } "
+.BI pfnum " PFNUMBER "
 Specifies PCI pfnumber to use on which a SF device to create
 
 .TP
-.BR sfnum " { " sfnumber " } "
+.BI sfnum " SFNUMBER "
 Specifies sfnumber to assign to the device of the SF.
 This field is optional for those devices which supports auto assignment of the
 SF number.
 
 .TP
-.BR controller " { " controller " } "
+.BI controller " CNUM "
 Specifies controller number for which the SF port is created.
 This field is optional. It is used only when SF port is created for the
 external controller.
@@ -192,17 +192,17 @@ external controller.
 .SS devlink port function set - Set the port function attribute(s).
 
 .PP
-.B "DEV/PORT_INDEX"
+.I "DEV/PORT_INDEX"
 - specifies the devlink port to operate on.
 
 .TP
-.BR hw_addr " ADDR"
-- hardware address of the function to set. This is a Ethernet MAC address when
+.BI hw_addr " ADDR"
+Hardware address of the function to set. This is a Ethernet MAC address when
 port type is Ethernet.
 
 .TP
 .BR state " { " active " | " inactive " } "
-- new state of the function to change to.
+New state of the function to change to.
 
 .I active
 - Once configuration of the function is done, activate the function.
@@ -213,13 +213,13 @@ port type is Ethernet.
 .ti -8
 .SS devlink port del - delete a devlink port
 .PP
-.B "DEV/PORT_INDEX"
+.I "DEV/PORT_INDEX"
 - specifies the devlink port to delete.
 
 .ti -8
 .SS devlink port param set  - set new value to devlink port configuration parameter
 .PP
-.B "DEV/PORT_INDEX"
+.I "DEV/PORT_INDEX"
 - specifies the devlink port to operate on.
 
 .TP
@@ -246,7 +246,7 @@ Configuration mode in which the new value is set.
 .SS devlink port param show - display devlink port supported configuration parameters attributes
 
 .PP
-.B "DEV/PORT_INDEX"
+.I "DEV/PORT_INDEX"
 - specifies the devlink port to operate on.
 
 .B name
-- 
2.31.1

