Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018DE212CCD
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 21:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgGBTKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 15:10:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55976 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgGBTKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 15:10:36 -0400
Received: from ip5f5af08c.dynamic.kabel-deutschland.de ([95.90.240.140] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jr4bJ-0006To-N4; Thu, 02 Jul 2020 19:10:25 +0000
Date:   Thu, 2 Jul 2020 21:10:25 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Matt Bennett <matt.bennett@alliedtelesis.co.nz>,
        netdev@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, zbr@ioremap.net
Subject: Re: [PATCH 0/5] RFC: connector: Add network namespace awareness
Message-ID: <20200702191025.bqxqwsm6kwnhm2p7@wittgenstein>
References: <20200702002635.8169-1-matt.bennett@alliedtelesis.co.nz>
 <87h7uqukct.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87h7uqukct.fsf@x220.int.ebiederm.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 08:17:38AM -0500, Eric W. Biederman wrote:
> Matt Bennett <matt.bennett@alliedtelesis.co.nz> writes:
> 
> > Previously the connector functionality could only be used by processes running in the
> > default network namespace. This meant that any process that uses the connector functionality
> > could not operate correctly when run inside a container. This is a draft patch series that
> > attempts to now allow this functionality outside of the default network namespace.
> >
> > I see this has been discussed previously [1], but am not sure how my changes relate to all
> > of the topics discussed there and/or if there are any unintended side effects from my draft
> > changes.
> 
> Is there a piece of software that uses connector that you want to get
> working in containers?
> 
> I am curious what the motivation is because up until now there has been
> nothing very interesting using this functionality.  So it hasn't been
> worth anyone's time to make the necessary changes to the code.

Imho, we should just state once and for all that the proc connector will
not be namespaced. This is such a corner-case thing and has been
non-namespaced for such a long time without consistent push for it to be
namespaced combined with the fact that this needs quite some code to
make it work correctly that I fear we end up buying more bugs than we're
selling features. And realistically, you and I will end up maintaining
this and I feel this is not worth the time(?). Maybe I'm being too
pessimistic though.

Christian
