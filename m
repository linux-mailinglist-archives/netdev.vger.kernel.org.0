Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996C845D4FD
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 07:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349169AbhKYG4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 01:56:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:44651 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350385AbhKYGyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 01:54:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637823059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VoMnV17fxmODAs6ZuTxmDXbUKJdVNaT9xH+ZJR+Nje0=;
        b=XuXTYaIvWiDLwnQ5YkqLLnE7wfZ5DICckqoq3JdnC1cNiRXnNTe87JZb3stgN/ML9yB+MZ
        za1i8ppWKxpwv23CSfScWPte5JJgU2C8AzSgU1KOxVrH/uNVo6JKEesAfy8wl6qmtrSanP
        IAKvrnD9mVoJhEaHTrnc0B9X+3lc35Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-519-bOUiz4UXPtaPyulYmBEzjA-1; Thu, 25 Nov 2021 01:50:55 -0500
X-MC-Unique: bOUiz4UXPtaPyulYmBEzjA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8605D1023F4D;
        Thu, 25 Nov 2021 06:50:53 +0000 (UTC)
Received: from x230 (unknown [10.39.192.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 71B5E60BF4;
        Thu, 25 Nov 2021 06:50:51 +0000 (UTC)
Date:   Thu, 25 Nov 2021 07:50:49 +0100
From:   Stefan Assmann <sassmann@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        netdev@vger.kernel.org,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: Re: [PATCH net-next 06/12] iavf: Add trace while removing device
Message-ID: <20211125065049.hwubag5eherksrle@x230>
References: <20211124171652.831184-1-anthony.l.nguyen@intel.com>
 <20211124171652.831184-7-anthony.l.nguyen@intel.com>
 <20211124154811.6d9c48cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124154811.6d9c48cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-24 15:48, Jakub Kicinski wrote:
> On Wed, 24 Nov 2021 09:16:46 -0800 Tony Nguyen wrote:
> > Add kernel trace that device was removed.
> > Currently there is no such information.
> > I.e. Host admin removes a PCI device from a VM,
> > than on VM shall be info about the event.
> > 
> > This patch adds info log to iavf_remove function.
> 
> Why is this an important thing to print to logs about?
> If it is why is PCI core not doing the printing?
> 

From personal experience I'd say this piece of information has value,
especially when debugging it can be interesting to know exactly when the
driver was removed.

  Stefan

