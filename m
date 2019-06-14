Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7A98456FD
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 10:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfFNIKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 04:10:08 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33334 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbfFNIKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 04:10:07 -0400
Received: by mail-wr1-f67.google.com with SMTP id n9so1522466wru.0
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 01:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=48589Ux64nCstGUm0j3kMsMx65XgsYNhjQrB8G4KWwI=;
        b=m46Pj7O6oAzX4Ts6MNfq2lzCyNqp4hcz1p9vSCuSMvnEsOWoWgVoUBzWeCsGwIYcv+
         sHj+Q7nNKycZkAAqRAjzS9DAdDDwy72r3gOKwplnLgsOvM5Z0ognMDsHTgqvND+z2dxu
         3ou6iqS0kNakCXrZR+Chb4YmS8h9kowiYJW1pfDvMzW/Bwj1ISXC7aIslfJMGc6q03sC
         nW9kKqBeMh7NSdvvX783gTOchLP1qR9VfLRZzrLgDIzLwy8PsgcvaIWaKcs/X/UO+5QD
         8pbqOZ7cmKpWZyPP7riJVmtp+fahUDiABqEhLFmtGFmD7nnlX+fXbcyTF8yZtt0fl2Nl
         Z6hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=48589Ux64nCstGUm0j3kMsMx65XgsYNhjQrB8G4KWwI=;
        b=IrfmK9mODJKUyTJihYxjASnW6cTW0BHlZxaGKxPE7pq+RGVsVIAeHliRzr8pCsxLqo
         86nr55T2Ez9AjHfR0u1hw0s+kDD7eSnbSQrgBU2wzULURwP32kKSn9pgjwbGNYza4Bkv
         N0kGrotBARuLJC1FLWz+G9odxiVB6dHYBnkrQLXOqhbj14yuiVC/+TYGSjCiX59DLHIi
         s/rlbU5SbKpuEnhGkEyAf+dfSBa6HyNL62MJC4cniUAQp+oB3nSf4RcjqBfTb0eHT4DH
         09zUWKHGmhES5GxqE2sQE2124GrpdiEOyNoH/dD48N+u93wup2eo7IOz2AwDnB40LZTc
         NNOQ==
X-Gm-Message-State: APjAAAWlhxLSr3W9x/izyouw1GXUqdFz+GqAFKHw0SMeLyq2qeQd/4oX
        vJ0vfNAGtXDStmIK1VeXZ3j4gJpkqfLbqQ==
X-Google-Smtp-Source: APXvYqyMgBVHXMWnVEupCT5uf3ePllXsNafDyZ5FzUanAvtErjRTquxWBNSgygUegZFeHtrmdlhszw==
X-Received: by 2002:adf:fbc2:: with SMTP id d2mr16948371wrs.334.1560499805773;
        Fri, 14 Jun 2019 01:10:05 -0700 (PDT)
Received: from localhost (ip-78-45-163-56.net.upcbroadband.cz. [78.45.163.56])
        by smtp.gmail.com with ESMTPSA id x6sm3064794wru.0.2019.06.14.01.10.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 14 Jun 2019 01:10:05 -0700 (PDT)
Date:   Fri, 14 Jun 2019 10:10:04 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     John Hurley <john.hurley@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        xiyou.wangcong@gmail.com, dcaratti@redhat.com,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com
Subject: Re: [PATCH net-next v2 1/3] net: sched: add mpls manipulation
 actions to TC
Message-ID: <20190614081004.GC2242@nanopsycho>
References: <1560447839-8337-1-git-send-email-john.hurley@netronome.com>
 <1560447839-8337-2-git-send-email-john.hurley@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560447839-8337-2-git-send-email-john.hurley@netronome.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jun 13, 2019 at 07:43:57PM CEST, john.hurley@netronome.com wrote:
>Currently, TC offers the ability to match on the MPLS fields of a packet
>through the use of the flow_dissector_key_mpls struct. However, as yet, TC
>actions do not allow the modification or manipulation of such fields.
>
>Add a new module that registers TC action ops to allow manipulation of
>MPLS. This includes the ability to push and pop headers as well as modify
>the contents of new or existing headers. A further action to decrement the
>TTL field of an MPLS header is also provided.
>
>Signed-off-by: John Hurley <john.hurley@netronome.com>
>Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

[...]


>+		if (tb[TCA_MPLS_LABEL] || tb[TCA_MPLS_TTL] || tb[TCA_MPLS_TC]) {
>+			NL_SET_ERR_MSG_MOD(extack,
>+					   "MPLS POP: unsupported attrs");

No need to break line here and couple other similar places in this code.
Anyway, looks good otherwise:

Acked-by: Jiri Pirko <jiri@mellanox.com>

[...]
