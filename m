Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF9FE28431
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 18:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730928AbfEWQqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 12:46:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55315 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729218AbfEWQqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 12:46:17 -0400
Received: from c-67-160-6-8.hsd1.wa.comcast.net ([67.160.6.8] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1hTqr9-0006wU-2r; Thu, 23 May 2019 16:46:15 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 2E6445FF12; Thu, 23 May 2019 09:46:13 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 28DAEA6E88;
        Thu, 23 May 2019 09:46:13 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     billcarlson@wkks.org
cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: bonding-devel mail list?
In-reply-to: <3428f1e4-e9e9-49c6-8ca8-1ea5e9fdd7ed@wkks.org>
References: <3428f1e4-e9e9-49c6-8ca8-1ea5e9fdd7ed@wkks.org>
Comments: In-reply-to Bill Carlson <billcarlson@wkks.org>
   message dated "Thu, 23 May 2019 10:31:09 -0500."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <18471.1558629973.1@famine>
Date:   Thu, 23 May 2019 09:46:13 -0700
Message-ID: <18472.1558629973@famine>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bill Carlson <billcarlson@wkks.org> wrote:

>Noted the old bonding-devel mail list at sourceforge is no more, is there
>an alternate?

	Use this list (netdev).

	Some time ago, I put a parking message on the bonding-devel list
redirecting people to netdev, but it appears that sourceforge deleted
the mailing list entirely at some point.

>Chasing whether a bond of bonds has an issue my testing hasn't revealed.

	As far as I'm aware, nesting bonds has no practical benefit; do
you have a use case for doing so?

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
