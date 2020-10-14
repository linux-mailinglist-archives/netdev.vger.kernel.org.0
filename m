Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9334828DD07
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 11:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730034AbgJNJV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 05:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731158AbgJNJVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 05:21:55 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A99C00214B
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 18:39:27 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id b6so461485pju.1
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 18:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yUC0rwUxYmJ6He1+DEtA27099aa0aLL7qdlDf/fhAwo=;
        b=dSPvtX1pJivkxtP16cpaCi1W9vgJmPRRYtNWPMfqObGwtEAjiAHex1xsjbzeuSwUbp
         kPC2ULiZZtVpu+9jodXOYVGt37rvGpD828CW7azcWmOcg3DxfLQzMLxtSOjT1f8DXkCa
         hRoekMja6V5Jw3GeP+M79cTk+qm8+QrDJBsHNQ2QcG1eccYeuLLCgdMD7p0ZRGxGxmTf
         BFfCXD6k/4Vji5ZpIHGXyXZeWFOhIwc+DZQ4liVq/xp7H4XnwzUFRtzWRg/esEHjZagP
         hDKyfx+BOeFXFi5XrY1QS21nMb4Ev9NVn61dGt8AP9YGOFkK+3dqeb9B9XYXSYkpPUmj
         t0FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yUC0rwUxYmJ6He1+DEtA27099aa0aLL7qdlDf/fhAwo=;
        b=V4U5OiaDkDqHdBTEDxidouYCn9Pzuz0zN3wXOC6sJGuidy8n4ZaznAfgoRA6+n47Rg
         gg8WltXd6+DFAHS0Afxev2QHzFvPJOx6AWYH6pDS+xjTkKz7G0MFjWYnJTvOqlyxO5Y9
         hEFRl5Rn37hDS4r46GDzGKmEY01Yzz7/ZbdWE4zHdaiOn7WJGh2zOrBciLpYr4/0c1Cu
         A8osCf+ZTOEamb/aqpz6jBU+cAJl3bUQmYxBDR6Zb0gJyQkjieYv+cbJNIpP/AncozCL
         Zaag8b5d7cJ2Bt8OeFzBbHHZJkwnP9zjPz7SQCUBhQDgQMGrCl3sL0JZGfdZtiUGuhpJ
         FM0A==
X-Gm-Message-State: AOAM5329QpFdp0udFlnMqxwTBchMijE0qxmRi93QTmkjFgC9BIRJRfF4
        XDRsAtY57giDh5lrelko2gA=
X-Google-Smtp-Source: ABdhPJzV+GnjIc4vUBnszrbkmfwJddBf07TOylxWkAW7tEaeYKvLk0vscfaPsqeUWzb7qSSeV993dQ==
X-Received: by 2002:a17:90a:bd97:: with SMTP id z23mr1142316pjr.191.1602639567069;
        Tue, 13 Oct 2020 18:39:27 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p12sm978345pgm.29.2020.10.13.18.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 18:39:26 -0700 (PDT)
Date:   Wed, 14 Oct 2020 09:39:16 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Ido Schimmel <idosch@mellanox.com>,
        Network Development <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: vxlan_asymmetric.sh test failed every time
Message-ID: <20201014013916.GM2531@dhcp-12-153.nay.redhat.com>
References: <20201013043943.GL2531@dhcp-12-153.nay.redhat.com>
 <20201013074930.GA4024934@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013074930.GA4024934@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 13, 2020 at 10:49:30AM +0300, Ido Schimmel wrote:
> On Tue, Oct 13, 2020 at 12:39:43PM +0800, Hangbin Liu wrote:
> > Hi Ido,
> > 
> > When run vxlan_asymmetric.sh on RHEL8, It failed every time. I though that
> > it may failed because the kernel version is too old. But today I tried with
> > latest kernel, it still failed. Would you please help check if I missed
> > any configuration?
> 
> Works OK for me:
> 
> $ sudo ./vxlan_asymmetric.sh veth0 veth1 veth2 veth3 veth4 veth5
> TEST: ping: local->local vid 10->vid 20                             [ OK ]
> TEST: ping: local->remote vid 10->vid 10                            [ OK ]
> TEST: ping: local->remote vid 20->vid 20                            [ OK ]
> TEST: ping: local->remote vid 10->vid 20                            [ OK ]
> TEST: ping: local->remote vid 20->vid 10                            [ OK ]
> INFO: deleting neighbours from vlan interfaces
> TEST: ping: local->local vid 10->vid 20                             [ OK ]
> TEST: ping: local->remote vid 10->vid 10                            [ OK ]
> TEST: ping: local->remote vid 20->vid 20                            [ OK ]
> TEST: ping: local->remote vid 10->vid 20                            [ OK ]
> TEST: ping: local->remote vid 20->vid 10                            [ OK ]
> TEST: neigh_suppress: on / neigh exists: yes                        [ OK ]
> TEST: neigh_suppress: on / neigh exists: no                         [ OK ]
> TEST: neigh_suppress: off / neigh exists: no                        [ OK ]
> TEST: neigh_suppress: off / neigh exists: yes                       [ OK ]
> 
> # uname -r
> 5.9.0-rc8-custom-36808-gccdf7fae3afa
> 
> # ip -V
> ip utility, iproute2-5.8.0
> 
> # netsniff-ng -v
> netsniff-ng 0.6.7 (Polygon Window), Git id: (none)
> 
> The first failure might be related to your rp_filter settings. Can you
> please try with this patch?
> 
> diff --git a/tools/testing/selftests/net/forwarding/vxlan_asymmetric.sh b/tools/testing/selftests/net/forwarding/vxlan_asymmetric.sh
> index a0b5f57d6bd3..0727e2012b68 100755
> --- a/tools/testing/selftests/net/forwarding/vxlan_asymmetric.sh
> +++ b/tools/testing/selftests/net/forwarding/vxlan_asymmetric.sh
> @@ -215,10 +215,16 @@ switch_create()
>  
>         bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 10
>         bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 20
> +
> +       sysctl_set net.ipv4.conf.all.rp_filter 0
> +       sysctl_set net.ipv4.conf.vlan10-v.rp_filter 0
> +       sysctl_set net.ipv4.conf.vlan20-v.rp_filter 0
>  }
>  
>  switch_destroy()
>  {
> +       sysctl_restore net.ipv4.conf.all.rp_filter
> +
>         bridge fdb del 00:00:5e:00:01:01 dev br1 self local vlan 20
>         bridge fdb del 00:00:5e:00:01:01 dev br1 self local vlan 10
>  
> @@ -359,6 +365,10 @@ ns_switch_create()
>  
>         bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 10
>         bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 20
> +
> +       sysctl_set net.ipv4.conf.all.rp_filter 0
> +       sysctl_set net.ipv4.conf.vlan10-v.rp_filter 0
> +       sysctl_set net.ipv4.conf.vlan20-v.rp_filter 0
>  }
>  export -f ns_switch_create

Thanks a lot for help debugging this issue, this patch works for me.

Tested-by: Hangbin Liu <liuhangbin@gmail.com>
