Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE888523DB
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 09:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729675AbfFYHCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 03:02:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49260 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727112AbfFYHCV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 03:02:21 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 77F883086218;
        Tue, 25 Jun 2019 07:02:11 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 284425D70D;
        Tue, 25 Jun 2019 07:02:05 +0000 (UTC)
Message-ID: <3ffd1c736a322ac36e0a5a88a1203e762529e7a3.camel@redhat.com>
Subject: Re: [PATCH net-next 1/1] tc-testing:  Restore original behaviour
 for namespaces in tdc
From:   Davide Caratti <dcaratti@redhat.com>
To:     Lucas Bates <lucasb@mojatatu.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nicolas.dichtel@6wind.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        mleitner@redhat.com, vladbu@mellanox.com, kernel@mojatatu.com
In-Reply-To: <1561424427-9949-1-git-send-email-lucasb@mojatatu.com>
References: <1561424427-9949-1-git-send-email-lucasb@mojatatu.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Tue, 25 Jun 2019 09:02:05 +0200
Mime-Version: 1.0
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Tue, 25 Jun 2019 07:02:21 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-06-24 at 21:00 -0400, Lucas Bates wrote:
> This patch restores the original behaviour for tdc prior to the
> introduction of the plugin system, where the network namespace
> functionality was split from the main script.
> 
> It introduces the concept of required plugins for testcases,
> and will automatically load any plugin that isn't already
> enabled when said plugin is required by even one testcase.
> 
> Additionally, the -n option for the nsPlugin is deprecated
> so the default action is to make use of the namespaces.
> Instead, we introduce -N to not use them, but still create
> the veth pair.
> 
> buildebpfPlugin's -B option is also deprecated.
> 
> If a test cases requires the features of a specific plugin
> in order to pass, it should instead include a new key/value
> pair describing plugin interactions:
> 
>         "plugins": {
>                 "requires": "buildebpfPlugin"
>         },
> 
> A test case can have more than one required plugin: a list
> can be inserted as the value for 'requires'.
> 
> Signed-off-by: Lucas Bates <lucasb@mojatatu.com>
> ---

hi Lucas,

thanks a lot for including a fix for buildebpfPlugin!

Acked-by: Davide Caratti <dcaratti@redhat.com>

