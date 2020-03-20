Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE27818CAE2
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 10:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbgCTJyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 05:54:16 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45461 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbgCTJyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 05:54:14 -0400
Received: by mail-wr1-f68.google.com with SMTP id t7so1928753wrw.12
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 02:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xLI0lJgS1luRIDVD+HRPjfuY3MCtwXFXdY5FidXwAoY=;
        b=1vdqzkBvV2g+vfWf2tYwYaZR2HmlJMdlLTRxgkTTZ8/wSyrrm4Zt9NWS+cniQpEMaS
         9PKb08weXgRa5ASm+9nHcLtof6OugMaBfr9+vFVtf0B5uHKvTpRL4IWImqVk4Bra+rtz
         JnrXSE9XshGnCv6SbsZ1Ssed0egZybvKGzc/ZCUeq9+6UfadO/euOnuCiXhDEeaOrVZp
         tKMTZ/FSm6Tjdx/WBZhh2J0prqJY67twQeq+QFr22kI9ikaf635t3qiAnLUBQJpPLNrN
         jf9BNdYMxEm8NYCq97/8WpNXmYXcDGyVfAmyBiLw0t4Yx1L8o6XfAov9odG8b511Dd8M
         VeCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xLI0lJgS1luRIDVD+HRPjfuY3MCtwXFXdY5FidXwAoY=;
        b=mit5G24BqWxkLGzuZUdWkrMmRrTSBcOqFXamXu52FASnWIGL2jEVPiWpD+E4QwjghQ
         z9tpNorXr9tF0K8QNe7Mf1a9syZrqtqZBPo/+Vr2vDVO5W2SGUBOPfzCsaZYCGupQnUz
         LbJxFGK0hHQ5iRJsQlMNIjEGovqHlm/wSGqQfAuR7uur105pfRmIpU5E0SRMihh28s49
         1gyhvLCTxoqtc+JjPQa3pYmXWVyEzkqifsRKqps6YutITqdkDqWQ9n3/QkeCHojJw7j9
         SOSru4wLD/WQ1qf6tX5GCHKINIJbMn0XpXXxgHoUUf/VWY9Od8aqmoUjDE5Jhu/WGklS
         FjOw==
X-Gm-Message-State: ANhLgQ3Oj+ceipLDY6NBlJNOKDzbRBTo9b9tDWR0h7TObE15yi0JBB+F
        ha2aPKSL+s/JFFQsJaXuaf5dlPvDH7c=
X-Google-Smtp-Source: ADFU+vt+hJJLc7/k18MSvBZKU3o755p8iv5auhj7M/LNt1PApTrKW/2EvQeNtn2KSd8VHtxXAVYvMQ==
X-Received: by 2002:adf:ab54:: with SMTP id r20mr9885176wrc.197.1584698051319;
        Fri, 20 Mar 2020 02:54:11 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id h13sm7526426wrv.39.2020.03.20.02.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 02:54:10 -0700 (PDT)
Date:   Fri, 20 Mar 2020 10:54:09 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: sched: rename more stats_types
Message-ID: <20200320095409.GF11304@nanopsycho.orion>
References: <20200319232623.102700-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319232623.102700-1-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Mar 20, 2020 at 12:26:23AM CET, kuba@kernel.org wrote:
>Commit 53eca1f3479f ("net: rename flow_action_hw_stats_types* ->
>flow_action_hw_stats*") renamed just the flow action types and
>helpers. For consistency rename variables, enums, struct members
>and UAPI too (note that this UAPI was not in any official release,
>yet).
>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Thanks Jakub.
