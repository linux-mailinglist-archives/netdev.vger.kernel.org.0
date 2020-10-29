Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F38AA29F372
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 18:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbgJ2RjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 13:39:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32783 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725849AbgJ2RjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 13:39:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603993147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AE8iG4REro15Im3TL5Naa7NUzTu8WebRiVJY/Ow6g80=;
        b=JNLfL+q2RgtgnkVSvL8NoQwm+5CTHiXNrsQPQvpzFbltdu1Fr+2N4r1PcUgZhwvdDd7E8o
        7AgYryNTBSbce1euEJTyM5j9yWE8dkv8rxk3hlZAk3OMbHsVWvnos0GnrgeqFiTVUz0xcO
        wD3aIRuqhEpcYtl6g4+uJAu5rwzOPjA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-9SpVsVVpP3WLKtG8tVAufA-1; Thu, 29 Oct 2020 13:39:02 -0400
X-MC-Unique: 9SpVsVVpP3WLKtG8tVAufA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F86C807342;
        Thu, 29 Oct 2020 17:39:01 +0000 (UTC)
Received: from ovpn-115-9.ams2.redhat.com (ovpn-115-9.ams2.redhat.com [10.36.115.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5C9B3614F5;
        Thu, 29 Oct 2020 17:38:58 +0000 (UTC)
Message-ID: <8fad8d1ae7554fe4f752f86016a0a0f2eaca8f89.camel@redhat.com>
Subject: Re: [PATCH net-next 2/3] net/core: introduce default_rps_mask netns
 attribute
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>
Date:   Thu, 29 Oct 2020 18:38:57 +0100
In-Reply-To: <20201029081632.2516a39b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <cover.1603906564.git.pabeni@redhat.com>
         <9e86568c264696dbe0fd44b2a8662bd233e2c3e8.1603906564.git.pabeni@redhat.com>
         <20201029081632.2516a39b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-10-29 at 08:16 -0700, Jakub Kicinski wrote:
> On Wed, 28 Oct 2020 18:46:02 +0100 Paolo Abeni wrote:
> > @@ -46,6 +47,54 @@ int sysctl_devconf_inherit_init_net __read_mostly;
> >  EXPORT_SYMBOL(sysctl_devconf_inherit_init_net);
> >  
> >  #ifdef CONFIG_RPS
> > +struct cpumask rps_default_mask;
> 
> net/core/sysctl_net_core.c:50:16: warning: symbol 'rps_default_mask' was not declared. Should it be static?

Thank you for the feedback! I'll address that in v2.

Cheers,

Paolo

