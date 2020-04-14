Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9642F1A8970
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503919AbgDNS1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:27:18 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46769 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2503916AbgDNS1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:27:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586888825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TLv7+DlAPTIRbMlPGq/MKTxn9g95YUGNwTJol6ZbUDE=;
        b=evzNfjaBoC6wCoS1V+bzcOYtHbD9SzXUS83ZXqorselZop7fMYVcJA2XhtVcujpFYBL4ZR
        tfmaAyfvPWvASv2oK5uwpQSjcj3C1oCqIsgQPNL61hTJ/MHoA/ncXstn457cJWAIA7hwex
        B+PnsH/bRW41yP4beWIBSvT1KRsWynM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-lrwga1poPzOYOa4E2pXY4A-1; Tue, 14 Apr 2020 14:27:01 -0400
X-MC-Unique: lrwga1poPzOYOa4E2pXY4A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E975D13FA;
        Tue, 14 Apr 2020 18:26:55 +0000 (UTC)
Received: from llong.remote.csb (ovpn-118-173.rdu2.redhat.com [10.10.118.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 936D410013A1;
        Tue, 14 Apr 2020 18:26:48 +0000 (UTC)
Subject: Re: [PATCH 1/2] mm, treewide: Rename kzfree() to kfree_sensitive()
To:     dsterba@suse.cz, Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Matthew Wilcox <willy@infradead.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-crypto@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-ppp@vger.kernel.org,
        wireguard@lists.zx2c4.com, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-fscrypt@vger.kernel.org, ecryptfs@vger.kernel.org,
        kasan-dev@googlegroups.com, linux-bluetooth@vger.kernel.org,
        linux-wpan@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-nfs@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        cocci@systeme.lip6.fr, linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org
References: <20200413211550.8307-1-longman@redhat.com>
 <20200413211550.8307-2-longman@redhat.com>
 <20200414124854.GQ5920@twin.jikos.cz>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <3d8c80cb-68e5-9211-9eda-bc343ed7d894@redhat.com>
Date:   Tue, 14 Apr 2020 14:26:48 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200414124854.GQ5920@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/14/20 8:48 AM, David Sterba wrote:
> On Mon, Apr 13, 2020 at 05:15:49PM -0400, Waiman Long wrote:
>>  fs/btrfs/ioctl.c                              |  2 +-
>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 40b729dce91c..eab3f8510426 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -2691,7 +2691,7 @@ static int btrfs_ioctl_get_subvol_info(struct file *file, void __user *argp)
>>  	btrfs_put_root(root);
>>  out_free:
>>  	btrfs_free_path(path);
>> -	kzfree(subvol_info);
>> +	kfree_sensitive(subvol_info);
> This is not in a sensitive context so please switch it to plain kfree.
> With that you have my acked-by. Thanks.
>
Thanks for letting me know about. I think I will send it out as a
separate patch.

Cheers,
Longman

