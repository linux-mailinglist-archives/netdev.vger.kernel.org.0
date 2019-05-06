Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03DD6149A2
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 14:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbfEFMfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 08:35:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44200 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbfEFMfC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 08:35:02 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7B7EE307EA84;
        Mon,  6 May 2019 12:35:02 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9EC015DD9A;
        Mon,  6 May 2019 12:35:01 +0000 (UTC)
Message-ID: <019486c8cbe636ad2ab2c529de48182e041d1ff1.camel@redhat.com>
Subject: Re: [PATCH iproute2-next v2] tc: add support for plug qdisc
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Ahern <dsahern@gmail.com>, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org
Date:   Mon, 06 May 2019 14:35:00 +0200
In-Reply-To: <69ac0f81-76e6-391f-83df-727783f48956@gmail.com>
References: <fe5c248b0eb19a2dd42bb1bff8a0c40c1e9e969f.1556640913.git.pabeni@redhat.com>
         <69ac0f81-76e6-391f-83df-727783f48956@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Mon, 06 May 2019 12:35:02 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2019-05-04 at 10:14 -0600, David Ahern wrote:
> On 4/30/19 10:53 AM, Paolo Abeni wrote:
> > sch_plug can be used to perform functional qdisc unit tests
> > controlling explicitly the queuing behaviour from user-space.
> 
> Hi Paolo:
> Do you have or are you planning to write unit tests?

whoops, I must admit I was not aware of iproute2/testsuite.

Some kernel work is needed for a proper selftest, as sch_plug dump() is
currently missing.

I'll try to give that a spin when net-next will re-open

Thanks,

Paolo

