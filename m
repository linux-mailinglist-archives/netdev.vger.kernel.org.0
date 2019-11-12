Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C266F9373
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 15:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfKLO6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 09:58:40 -0500
Received: from mail-wm1-f52.google.com ([209.85.128.52]:52104 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbfKLO6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 09:58:40 -0500
Received: by mail-wm1-f52.google.com with SMTP id q70so3549884wme.1
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 06:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=njh/0u+cvSu0Rt12PZPMDyzssDvMBASpLgsQIpvEwiY=;
        b=pYImXkCp4p0qdzYl3bLmTZwJvGQIitl6+v4ffKtWKUTFd5UJlXUenFy4j6fhB9y55w
         W2sHtAfqNm3C3B7w3FnRE2d+DCxEhhgZN2gz2OcaZ66GSeGuRRQ/PV+lJtdW/liW2Wcs
         eT42pRQivMwOH2W47JJv54J7ZRsMVpNGGFXCJo1DfePIUSt4B1dcKfUrqsZvl10V+Lob
         83PdgIob1CskMDCPwafEIuVnWI9TYjHLArZkVZFHskMfKYQFTM2A9zSjbOELnvK91Qyz
         EsJ+AYJ6679glyYAorv/E8XAhaVw4qip8fQIZ1B4EYCFtVtK0MS+s3sFiw17BiHTkcXp
         rYyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=njh/0u+cvSu0Rt12PZPMDyzssDvMBASpLgsQIpvEwiY=;
        b=NuC2lBAp/VsmDXihnN28IkMhAl3Vd8E6or5ge/ImuuVR02x4oftkICgz3WEmHPlIET
         4vHL5rE+vq5OrrTkrUqJFt2Lvm7sCkC8OnSV8iTOxiHH1+QuvDm18AT2y+1CgsOSJq0n
         q5piBpdMzpKkVi3sfgOzDZG9FHIMS8pOpIvh/hvpHKN1x+oh9Z9RvIhqdRRbL5koV6oz
         JplNtxSm2AQeJxQCYCGFR7PQnWzuChwFYUBazpCZV5RuKLQXE/Wpq2o4e8vQFOIYv5Ya
         udxRzUdruaAy67SGhHUn19fPYi8SuQ/Ajbn+kTj0ZvpRHjjAB+rH9dyitD+MWYA2MqJs
         Z0EA==
X-Gm-Message-State: APjAAAUoYZFhHu6E5LrEHoFF32L3YCLKPFJR2U1d2oujwYEUgpDuMJuO
        0boa3TPQQSk7gngWexYPJp/r1A==
X-Google-Smtp-Source: APXvYqzOWcCs2EQgvJG+h+13shnaBYhkDDsK0a/BcOIZh/FTLoxeVKdhkoHYDdK0eIpQSLmr/NdwXQ==
X-Received: by 2002:a1c:7f54:: with SMTP id a81mr4452075wmd.48.1573570718413;
        Tue, 12 Nov 2019 06:58:38 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id w11sm15938968wra.83.2019.11.12.06.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 06:58:37 -0800 (PST)
Date:   Tue, 12 Nov 2019 15:58:37 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Vlad Buslov <vladbu@mellanox.com>, netdev@vger.kernel.org,
        Ivan Vecera <ivecera@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next] net/sched: actions: remove unused 'order'
Message-ID: <20191112145837.GA2154@nanopsycho>
References: <e50fe84bfbe3c6fa8c424a5a0af9074c2df63826.1573564420.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e50fe84bfbe3c6fa8c424a5a0af9074c2df63826.1573564420.git.dcaratti@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 12, 2019 at 03:33:11PM CET, dcaratti@redhat.com wrote:
>after commit 4097e9d250fb ("net: sched: don't use tc_action->order during
>action dump"), 'act->order' is initialized but then it's no more read, so
>we can just remove this member of struct tc_action.
>
>CC: Ivan Vecera <ivecera@redhat.com>
>Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
