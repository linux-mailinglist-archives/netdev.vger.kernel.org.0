Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1C420A4D0
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 20:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406141AbgFYSWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 14:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405815AbgFYSWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 14:22:34 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1F7C08C5C1;
        Thu, 25 Jun 2020 11:22:33 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id y10so6909726eje.1;
        Thu, 25 Jun 2020 11:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v8geYdYVNbF2rBwzEMDOXkFAFkAYNm3uyIolEhmynSQ=;
        b=oEi9td/3wSG1TfTzeZOqQLFC8Rylwdn1Ss0asHlgWIDEr2soxzQ+Q+ppWngvOk6QBj
         uplo7+7UTdsXYTPdi8xOk5s+qbUPaXTmNG51iKLyGKVvNEV9XNtEg7oQjqFAW6HO6P8J
         o5JBCvvo5VcoxhsdiWvWqwLDcq49JMPe+JLIYruYt/fodDhauPBz+DDr8UyXVtUzViiY
         FY7NZckqA10YV2rvfWJ1QHJBPdO0X039l1sqmufVs2JKcSzulo4MUOggJebgrxOQbDgu
         xpjMwZB7EfXMyuUrCFXLLsxN0MVVY6J5jhcADKKNjIZHpPlnQJhF75aAWcTLUMQw4V6p
         URMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v8geYdYVNbF2rBwzEMDOXkFAFkAYNm3uyIolEhmynSQ=;
        b=h7eVARcohrumS6VsThxbroop2NQ3LEF+IhoC2Zrt/7MX+R6uKU9RpaoznlL6/qKz+G
         vBkU3jk/jgAl+VzLqTQRqtKy9ZvmmPqOSwMKUkoQ8/9ALfd3kog8OBLGhclPo5muObhU
         IOE7wfDCeWy8asp6aVyPTXzSdFtkmKP8K+GIhqzaJ886FJe0S4wKbZ1Sc/4/SxMzyjTp
         EGb3NVw1DTHOB9CJMIyeUJts3h9Xd0TmAOGf/FVIZQTdkWbM8chfZKjOLvFdDOZTP0Nk
         ZANAfMqFxv/joM5/VCWAFDk2W6OCJPXmiOsu4wHGGm46om+W4miUlI6cz8sZwh+jxAcl
         9LrA==
X-Gm-Message-State: AOAM53302myCh9kQL1B+1wq50Xm5SM2SRIZs9mDQE+j8ny2gOoxt2rfZ
        ny96wtfuxcTAmTC6/5xC4xo=
X-Google-Smtp-Source: ABdhPJwYuKHKu8ML78wL+jaQLqXrQCzIvC0LSKLl8JU//05HxvBuQruSWlLJAM3qfISlZB1rhyLmBg==
X-Received: by 2002:a17:906:da19:: with SMTP id fi25mr9261887ejb.369.1593109352334;
        Thu, 25 Jun 2020 11:22:32 -0700 (PDT)
Received: from andrea (ip-213-220-210-175.net.upcbroadband.cz. [213.220.210.175])
        by smtp.gmail.com with ESMTPSA id lm22sm1524867ejb.109.2020.06.25.11.22.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 11:22:31 -0700 (PDT)
Date:   Thu, 25 Jun 2020 20:22:23 +0200
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Andres Beltran <lkmlabelt@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, mikelley@microsoft.com,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 0/3] Drivers: hv: vmbus: vmbus_requestor data structure
Message-ID: <20200625182223.GA318674@andrea>
References: <20200625153723.8428-1-lkmlabelt@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625153723.8428-1-lkmlabelt@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Andres Beltran (3):
>   Drivers: hv: vmbus: Add vmbus_requestor data structure for VMBus
>     hardening
>   scsi: storvsc: Use vmbus_requestor to generate transaction ids for
>     VMBus hardening
>   hv_netvsc: Use vmbus_requestor to generate transaction ids for VMBus
>     hardening

For the series,

Tested-by: Andrea Parri <parri.andrea@gmail.com>

Thanks,
  Andrea
