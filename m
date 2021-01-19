Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C612FAE3F
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 02:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391692AbhASBGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 20:06:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26751 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729918AbhASBGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 20:06:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611018276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=saOK2rQZ8LvjXL+D11visYuXDiXxSd5YTYGDgVAQGHk=;
        b=YRcOscQGp2DkqNg/sbo7Scw7kCq9Mul15qg1N4NFhob8yuHUqs9OnybFzqLJQWnO/mueKa
        6xoP9kovQXjnaiG9TfvgnkXVISyBCftpazoxhEcNpCypDryd7fWggaYIxQwhLpiNHepF1s
        zyrBRqOllMLauthSmo+uSJt1k1CKrqI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-eF1HJRQnOjq782tDW6jN7Q-1; Mon, 18 Jan 2021 20:04:32 -0500
X-MC-Unique: eF1HJRQnOjq782tDW6jN7Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 627F13E751;
        Tue, 19 Jan 2021 01:04:30 +0000 (UTC)
Received: from redhat.com (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F24F210023AB;
        Tue, 19 Jan 2021 01:04:28 +0000 (UTC)
Date:   Mon, 18 Jan 2021 20:04:27 -0500
From:   Jarod Wilson <jarod@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3] bonding: add a vlan+srcmac tx hashing option
Message-ID: <20210119010427.GB1191409@redhat.com>
References: <20210113223548.1171655-1-jarod@redhat.com>
 <20210115192103.1179450-1-jarod@redhat.com>
 <79af4145-48cc-0961-b341-c0e106beb14b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79af4145-48cc-0961-b341-c0e106beb14b@gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 04:10:38PM -0700, David Ahern wrote:
> On 1/15/21 12:21 PM, Jarod Wilson wrote:
> > diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
> > index adc314639085..36562dcd3e1e 100644
> > --- a/Documentation/networking/bonding.rst
> > +++ b/Documentation/networking/bonding.rst
> > @@ -951,6 +951,19 @@ xmit_hash_policy
> >  		packets will be distributed according to the encapsulated
> >  		flows.
> >  
> > +	vlan+srcmac
> > +
> > +		This policy uses a very rudimentary vland ID and source mac
> 
> s/vland/vlan/
> 
> > +		ID hash to load-balance traffic per-vlan, with failover
> 
> drop ID on this line; just 'source mac'.

Bah. Crap. Didn't test documentation, clearly. Or proof-read it. Will fix
in v4. Hopefully, nothing else to change though...

-- 
Jarod Wilson
jarod@redhat.com

