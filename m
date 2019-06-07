Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B752938E52
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 17:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729539AbfFGPCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 11:02:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41500 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728682AbfFGPCg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 11:02:36 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C9DDE30058D9;
        Fri,  7 Jun 2019 15:02:36 +0000 (UTC)
Received: from Hades.local (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1026D104B50D;
        Fri,  7 Jun 2019 15:02:34 +0000 (UTC)
Subject: Re: [PATCH net] bonding: make debugging output more succinct
To:     linux-kernel@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20190607145933.37058-1-jarod@redhat.com>
 <20190607145933.37058-9-jarod@redhat.com>
From:   Jarod Wilson <jarod@redhat.com>
Message-ID: <0e12b390-9b47-ae24-3a1b-4f602c57a779@redhat.com>
Date:   Fri, 7 Jun 2019 11:02:34 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190607145933.37058-9-jarod@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Fri, 07 Jun 2019 15:02:36 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/7/19 10:59 AM, Jarod Wilson wrote:
> Seeing bonding debug log data along the lines of "event: 5" is a bit spartan,
> and often requires a lookup table if you don't remember what every event is.
> Make use of netdev_cmd_to_name for an improved debugging experience, so for
> the prior example, you'll see: "bond_netdev_event received NETDEV_REGISTER"
> instead (both are prefixed with the device for which the event pertains).
> 
> There are also quite a few places that the netdev_dbg output could stand to
> mention exactly which slave the message pertains to (gets messy if you have
> multiple slaves all spewing at once to know which one they pertain to).

Argh. Please drop this one, detritus in my git tree when I hit git 
send-email caused this earlier iteration of patch 1 of the set this is 
threaded with to go out.

-- 
Jarod Wilson
jarod@redhat.com
