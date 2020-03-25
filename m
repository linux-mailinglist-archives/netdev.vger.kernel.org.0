Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2909F192A6C
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 14:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbgCYNuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 09:50:25 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55736 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727374AbgCYNuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 09:50:24 -0400
Received: by mail-wm1-f66.google.com with SMTP id z5so2526858wml.5
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 06:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3/JtSL/UFM9Xe+FkmPvoYh8qoA62zLfFqaPloO2xxkA=;
        b=Ke1XUEVJE4OF4d99VLzp9+quiMayucF4LdS0KfLkzk9lPuOyl5uk+neQZ6CPZ9hYKA
         wAZ1KbBO9OpxsYRJCJVDLz/ljQTbGW7hRWSyx9daNk6BwGBa4A5qQ0V1C39BueW1OOjM
         miyboK2RulpvMrhYw8XFFDLticDoIhqguD3JCc4VVuN3bqUUYQtRexkjkzZjhr2XcUYi
         hbKDCi35sErtXwhOZ7LKyd0+jZkhEZTjrHKCGyN1EEDGvDI5J/rHPDYpH3tmyV2B9vEg
         bDcNKcA1NLDsUTpUR3lRZiuc0TUDS8yru0lEC0KuH9duC6wAdEwt8vfmRMEEqmVC4qdL
         /iUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3/JtSL/UFM9Xe+FkmPvoYh8qoA62zLfFqaPloO2xxkA=;
        b=kRYybT8tU1NuDTX0Vn3rCDY7F+eXoc/Qw/b8bUO2Q5iuCRI4cr7teBJWUd/uqvU6VA
         PzUcWxzoz8s+dQlOBBfOdaoF9sip9to0MVgsS3DtyrvD0J/cqV8fBeaS0CHqTvT9JQvU
         GwnpgarC1oZpUgWVWtLqxKp5kDdqHTsszLJzhNYEGG92NUymacKMNKvyGGw2q9e8dGm5
         4NFD1rosi+jexXDmEIodYex7akTuhuN9GEmrgF7zex6T5mM3PNnj5DTb/wtgDq0N0KNL
         +u9TbxnK3KlhgPcB8y8dCCC1SSB9PUhYxsxPfoCAzN6wwQniK2T8s4+kt0i/5kxCdEVE
         OWXQ==
X-Gm-Message-State: ANhLgQ1aHaf3QhWDh726xQZ9NQD+eWgPdKvsaElsjIZr+V5fQe9flBrv
        +13/dPdgHO67EU9iAcJrFBGJQw==
X-Google-Smtp-Source: ADFU+vu+bU9/W9WK4/7W1l+cwb6pwFyydppCHIhHGOhPoHbBQlUpzT+0HfTG0+ORQGoZpYPi7lXXeA==
X-Received: by 2002:a1c:44b:: with SMTP id 72mr3704689wme.116.1585144221946;
        Wed, 25 Mar 2020 06:50:21 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id f12sm9333769wmh.4.2020.03.25.06.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 06:50:21 -0700 (PDT)
Date:   Wed, 25 Mar 2020 14:50:20 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 00/10] implement DEVLINK_CMD_REGION_NEW
Message-ID: <20200325135020.GW11304@nanopsycho.orion>
References: <20200324223445.2077900-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324223445.2077900-1-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Re subject. You should indicate what tree you are aiming at:
[patch net-next]
[patch net]
