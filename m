Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B21DF10BC3
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 19:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbfEARHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 13:07:14 -0400
Received: from namei.org ([65.99.196.166]:36874 "EHLO namei.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725973AbfEARHO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 13:07:14 -0400
Received: from localhost (localhost [127.0.0.1])
        by namei.org (8.14.4/8.14.4) with ESMTP id x41H7BMs015634;
        Wed, 1 May 2019 17:07:11 GMT
Date:   Thu, 2 May 2019 03:07:11 +1000 (AEST)
From:   James Morris <jmorris@namei.org>
To:     David Howells <dhowells@redhat.com>
cc:     dwalsh@redhat.com, vgoyal@redhat.com, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [GIT PULL] keys: Namespacing
In-Reply-To: <561.1556663960@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.21.1905020306290.14696@namei.org>
References: <561.1556663960@warthog.procyon.org.uk>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Apr 2019, David Howells wrote:

> Hi James,
> 
> Can you pull this set of patches into the security tree and pass them along
> to Linus in the next merge window?  The primary thrust is to add
> namespacing to keyrings.

Not for this merge window, it's too close. Something like this would need 
to be in -rc2 or so.


-- 
James Morris
<jmorris@namei.org>

