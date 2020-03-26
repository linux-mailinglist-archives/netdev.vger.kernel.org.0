Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70BE8194A5C
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 22:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgCZVS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 17:18:29 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56195 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbgCZVS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 17:18:28 -0400
Received: by mail-wm1-f65.google.com with SMTP id z5so8735241wml.5
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 14:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Fg56cwAo3UdD7KWU6kqDjKhXoAmkHXiSd8TUwYm6WdE=;
        b=tUJaSuG8pet5gwwDmiwK/Y78QsaoDD0sKuXWmV2CwnPgdGcJe6bPNujrzvJpYpBxdO
         HJH9edVx1OHId6Y0uO29KmwzSL+o2Y19Z8k39XsNtH8pntnrw60qn1Bu/2M25S+M97Rt
         H+RDhE2ULpeVqXALkkT0uYBH2nqa5/hpjOORyVojqsuGz5Jxg04uQdFyxeC0GexyML+r
         ei96eKcSxZmgu6yuhjoKAPrh/cZ/KhZxMymPgr0ggsMYcBSSz0LzNF0hzHgniJev8Rcw
         MVYOCbsJlezEpEzpJeNsueCL3NLg1GbF8ak0XAuYfOIJQKqFqhTd3CSG5KTqIjvEdLRj
         SL0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Fg56cwAo3UdD7KWU6kqDjKhXoAmkHXiSd8TUwYm6WdE=;
        b=tQQzKOQmYQI6DHkHoEmFAr8kcRsUzHGEpqiN7/cj1aTi6ePr35WvekVQaDzwweTHgB
         BfwsHq6LCDJyZzVqnJa/1GBDVdt4FTD+dlm8mjwrpAYIsKLRjfcZr3VD5cYde9onFrlj
         QN/XvZy18nYCjj5sv5lzFCofGUaBGDkzq0o+ihpNkmP4o9oFBq3ekOB/9XOHK1CtXnnL
         sIXnWT+toLfGotAlLNQW9nUQDq9AqmGNWMkk+SFXm1yZ+lOGnwTapmtPAUiAjNicubAO
         iRwYDs8XxevxfJK3RisQfkFF8OQ8IP0E+OuXa3L86BGx6wcvJDyyfDl22sE6DPQK84OW
         MU0g==
X-Gm-Message-State: ANhLgQ0vvShLHxoOt89z1uG2hOnO5hVJtNwBK1jNQK9tQcyox6h7oIHc
        wSAg0WrYvG3zrVZTxYSnTy8efw==
X-Google-Smtp-Source: ADFU+vu4bLCze6TNnanpipUrmnw3xwlI+nVHQn2jnqaERuceexm3JFLRcYnphwn5x4P1df3tEmG14g==
X-Received: by 2002:a1c:1f48:: with SMTP id f69mr2049479wmf.144.1585257506674;
        Thu, 26 Mar 2020 14:18:26 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id w204sm5352377wma.1.2020.03.26.14.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 14:18:26 -0700 (PDT)
Date:   Thu, 26 Mar 2020 22:18:25 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v3 10/11] netdevsim: support taking immediate
 snapshot via devlink
Message-ID: <20200326211825.GF11304@nanopsycho.orion>
References: <20200326183718.2384349-1-jacob.e.keller@intel.com>
 <20200326183718.2384349-11-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326183718.2384349-11-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 26, 2020 at 07:37:17PM CET, jacob.e.keller@intel.com wrote:
>Implement the .snapshot region operation for the dummy data region. This
>enables a region snapshot to be taken upon request via the new
>DEVLINK_CMD_REGION_SNAPSHOT command.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
