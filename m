Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAD9FB8EF
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 20:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfKMTen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 14:34:43 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36571 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbfKMTen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 14:34:43 -0500
Received: by mail-pl1-f195.google.com with SMTP id d7so1489848pls.3
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 11:34:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uFiiinmU7VuSwSjR0tRrB18CeSFkGpY08UzT3rIZvmc=;
        b=UV9Kf2gVOsBdO5ejOJwPlirMHT8i90Zaft/Qr8Sym9a1CDH8LOmJDq4yj6ly3qWye9
         4etKNUvzvDPo8y2j7RdURPvH6ix2mbxrxN1NE+WPudoYb0YJIKdl5BwxFnFb2zFaFpaV
         HsluNeyZV//JVobgKi2Q5sSVQUDzcSKn0orLWSVICaJry1hi9qY1/itnCEnY14kpGou4
         LKVxfn6NXOvy5JvxBXxG2f65zmwkYfp4uNZknGSiJCO4yCdW/Mw3eRNmf/PuL39nK2mo
         j79DfQrl/8SvGf6IRGHIwSf+gZJERJZkgxp0TZ6OwKSxlGBBccT5t3rheQgU5+j9fOUm
         zqjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uFiiinmU7VuSwSjR0tRrB18CeSFkGpY08UzT3rIZvmc=;
        b=I0/GhFfexHUJPEdH5YoyXQ2Xk8vNT4TAXEec+kXny4mApAcotPoRC62HCW2C/4JF4f
         aUKuv5nWHqxSJt8JNbjDqBKq2EMGbkqXKgsgHadtLDHlLhTjX4DLPwSLyH6Fuh//MVMf
         G2OKSjyVAJL96U11tHx/gF+0K8aoJh7rVxtp13ZBAe2l9yY65DypLzcdMhiHawelFekJ
         T5ZYeDOofziSe5AGGn4bmQNzK4rXLRB+tYiH8mA79fTYfN1rqttRh/8IjexBku//EwIA
         lLIaTc5NBreILlwkkpCIKAt/zB1QzJwPHnpwmwBqXc+9EnfUNLPokGHadGW5b1k0+02+
         lUZQ==
X-Gm-Message-State: APjAAAUkGVPm7t1DfmW6YhhgTUMATE0UuGRzPVEK0E8WHEPpl2uXuuSq
        gSTHiBV4QbpUBeVhp9ji440=
X-Google-Smtp-Source: APXvYqyOyqRgk9XA/5nMpx3rETdHgxbSmmSKl9+Au45Vh3PNZ6EWoe3rmaZuJB5Kds9JvfGgTyiLPw==
X-Received: by 2002:a17:902:8491:: with SMTP id c17mr3123821plo.143.1573673680863;
        Wed, 13 Nov 2019 11:34:40 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id z10sm3421558pgg.39.2019.11.13.11.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 11:34:40 -0800 (PST)
Date:   Wed, 13 Nov 2019 11:34:38 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org,
        Intel Wired LAN <intel-wired-lan@lists.osuosl.org>,
        Jeffrey Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [net-next v3 0/7] new PTP ioctl fixes
Message-ID: <20191113193438.GA7551@localhost>
References: <20190926181109.4871-1-jacob.e.keller@intel.com>
 <20191113015809.GA8608@localhost>
 <20191113171011.GA16997@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113171011.GA16997@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 13, 2019 at 09:10:11AM -0800, Richard Cochran wrote:
> On Tue, Nov 12, 2019 at 05:58:09PM -0800, Richard Cochran wrote:
> > There is still time before v5.4 gets released.  Would you care to
> > re-submit the missing six patches?
> 
> Or, if you don't mind, I can submit these for you, along with the
> STRICT flag checking for v2 ioctls that we discussed.

Okay, so I took the liberty of taking your series, picking up the
tags, and adding the new strict checking.  I'll post it later today or
early tomorrow after testing.

Thanks,
Richard
