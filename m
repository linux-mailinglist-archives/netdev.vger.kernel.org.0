Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B3E423E6C
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 15:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbhJFNLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 09:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbhJFNLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 09:11:35 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E3EC061749
        for <netdev@vger.kernel.org>; Wed,  6 Oct 2021 06:09:43 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id z20so9568374edc.13
        for <netdev@vger.kernel.org>; Wed, 06 Oct 2021 06:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VrAxJW9N298vympblU57dhExq6OxfCbK6fPvWqV0Tow=;
        b=lOenZw7wSMbJNhiZHAqa2oB0+OHiBA82uAIzdbXiJNOnFK5tnHV+Alye/tXUOWjZBd
         Yf+qQLIBc5EoOuzbIvq77vKJ6Z6qHwkMHPBZ26oiPs3aUFZb5dJk1QNvRL2gVlQEihw/
         77V7CadfszwOmlEeHuNQHbmnNAM94+g+YzEvv7pZtTDbxm7qarusr0PE3sj6SKmIm25r
         aMLSMkpanBnPHFhoclCPAg1XUggw66XDQWPbkrRs+q8182gwVMITsO7xe95/iW9kqOGy
         q+1Zria2KaGaZ+oZTlmwF6n8UGmGdv+j7W9Utx6srkgnS7TNaySG4aPtdYMoV338RuX+
         P4ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VrAxJW9N298vympblU57dhExq6OxfCbK6fPvWqV0Tow=;
        b=Jd+QuZMDlEKQgk7svRODmtgMiTSy4f7p5ldN1YYuZ8vkk08NIsk9N2610WBDB52wK3
         ja+UiQPMOegik5Elm2/NGL42MdlCdTY54spDy4+wf70gkRgmzfDfi9AUy+++cRWoQgUx
         /aSLAJPii6yaUM/cbLhQG/MM4bL4D0EIbl2o8qrc8L9QzJvgJJp81gbmSq/8wpMAnPjk
         4/BIXYBageejbr9D5kxDP9YKnvlrhg984bUw8xKYNMRph/T2a0MAGWb4FM6tXW1g206B
         ewC4O1PJJ4pEou2b44JW5LxKi24oVkZqLXs9sctX6/j3j0YvLDWEnXA5In+M4vwRM9ve
         /1ew==
X-Gm-Message-State: AOAM532JFv4A8zf54wLnptwHpZ2rzrDr3WtdKQetVxJ5bqJ5NeokSDum
        21R58CcvHMYnIXAl8cWX5NxT4v8BLhg=
X-Google-Smtp-Source: ABdhPJx8aUgX7l7PQqxBG8JoalaE2TMu66RN48w1KG9Txt8x1PUQGyaMMVBGKgmA8exXS1d5ejI9IA==
X-Received: by 2002:a17:906:3486:: with SMTP id g6mr33388855ejb.71.1633525778974;
        Wed, 06 Oct 2021 06:09:38 -0700 (PDT)
Received: from bullseye (84-104-224-163.cable.dynamic.v4.ziggo.nl. [84.104.224.163])
        by smtp.gmail.com with ESMTPSA id k12sm9010361ejk.63.2021.10.06.06.09.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 06:09:38 -0700 (PDT)
Date:   Wed, 6 Oct 2021 15:09:00 +0200
From:   Ruud Bos <kernel.hbk@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, davem@davemloft.net, kuba@kernel.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next 0/4] igb: support PEROUT and EXTTS PTP pin
 functions on 82580/i354/i350
Message-ID: <YV2f7F/WmuJq/A79@bullseye>
References: <20211006125825.1383-1-kernel.hbk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006125825.1383-1-kernel.hbk@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

My apologies for the huge delay in resending this patch set.

I tried  setting up my corporate e-mail to work on Linux to be able to use 
git send-email and getting rid of the automatically appended 
confidentiality claim. Eventually I gave up on getting this sorted, hence 
the different e-mail address.

Anyway, I have re-spun the patch series atop net-next.
Feedback is welcome.

Regards,
Ruud
