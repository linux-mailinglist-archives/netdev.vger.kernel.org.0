Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1996F02C1
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 10:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243136AbjD0Iny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 04:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243112AbjD0Inw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 04:43:52 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4C14C39
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 01:43:50 -0700 (PDT)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id C8EE92000C;
        Thu, 27 Apr 2023 08:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1682585028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ha8sbYwGMlEAIXxOdxTwhgQ8cNkCZ7qAj1dwjAIzP58=;
        b=lCLVQCJb83lV2zEHEGp74ZtTYV/ML4rDkFAMQyc8ZGkWa9xdJA+Y5zkuXrkY4J8fpqjBYk
        tUkjqjTMJ3m2Hsxbyd+VflivxulNgW8iIhDVRcK9kmNBqtOyuzLQqRcd4IumLe8V6grBE7
        oSBNxh23MmToaO8Fv3EK5INI3aPulL89HnY/7dNLBYAUD+Z0HFORo40S6LODgMVYtKFuye
        RI5EQc0qDM+yrhq97Gduw5Ph+YYkni5iC0Ewt1LRPILb7O+y7rNwQbflqq/zLx+dzFLBi6
        mEMvj6bzYLKTEUVfo5iIuU5FYw+8pGhd2d1Ebmey6vWiEjFuaYOvvpQutmY3Ww==
Date:   Thu, 27 Apr 2023 10:43:47 +0200
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     Max Georgiev <glipus@gmail.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com, thomas.petazzoni@bootlin.com
Subject: Re: [RFC PATCH v4 0/5] New NDO methods ndo_hwtstamp_get/set
Message-ID: <20230427102945.09cf0d7f@kmaincent-XPS-13-7390>
In-Reply-To: <CAP5jrPE3wpVBHvyS-C4PN71QgKXrA5GVsa+D=RSaBOjEKnD2vw@mail.gmail.com>
References: <20230423032437.285014-1-glipus@gmail.com>
        <20230426165835.443259-1-kory.maincent@bootlin.com>
        <CAP5jrPE3wpVBHvyS-C4PN71QgKXrA5GVsa+D=RSaBOjEKnD2vw@mail.gmail.com>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Apr 2023 22:00:43 -0600
Max Georgiev <glipus@gmail.com> wrote:

> 
> Thank you for giving it a try!
> I'll drop the RFC tag starting from the next iteration.

Sorry I didn't know the net-next submission rules. In fact keep the RFC tag
until net-next open again.
http://vger.kernel.org/~davem/net-next.html

Your patch series don't appear in the cover letter thread:
https://lore.kernel.org/all/20230423032437.285014-1-glipus@gmail.com/
I don't know if it comes from your e-mail or just some issue from lore but could
you check it?

Please add "net:" prefix to your patches commit title when changing the net
core, "macvlan:" prefix for macvlan driver change, etc ... 

Also I see you forgot "net-next" to the subject prefix in this iteration please
don't in next one.

Thanks for your work!
