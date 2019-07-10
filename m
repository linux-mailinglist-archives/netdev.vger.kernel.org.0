Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB03664355
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 10:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbfGJIHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 04:07:32 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:49738 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726134AbfGJIHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 04:07:32 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hl7dS-00068x-HX; Wed, 10 Jul 2019 10:07:30 +0200
Date:   Wed, 10 Jul 2019 10:07:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Naruto Nguyen <narutonguyen2018@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter@vger.kernel.org
Subject: Re: Question about nf_conntrack_proto for IPsec
Message-ID: <20190710080730.c4bjujzkqcjxevmf@breakpoint.cc>
References: <CANpxKHHXzrEpJPSj3x83+WE23G1W0KPz9XbG=fCVzS21+-BpfQ@mail.gmail.com>
 <20190626111322.gks5qptax3iqrjao@breakpoint.cc>
 <CANpxKHGa6DpV-9n8La7wh6r7MbEZpzGTWOO1AhmhWv072b4LAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpxKHGa6DpV-9n8La7wh6r7MbEZpzGTWOO1AhmhWv072b4LAg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Naruto Nguyen <narutonguyen2018@gmail.com> wrote:
> Could you please elaborate more on how generic tracker tracks ESP connection?

All protocols that do not have a more specific l4 tracker are tracked
based on l3 protocol + l4 proto number.

IOW, any ESP packet sent between the same endpoint addresses is seen
as matching a single esp flow.

We could easily add the ESP SPI as additional distinction marker if needed.
