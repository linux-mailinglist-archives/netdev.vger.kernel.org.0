Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91364308F89
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 22:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbhA2Vie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 16:38:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbhA2Vic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 16:38:32 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4762C061756
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 13:37:51 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id b21so12240767edy.6
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 13:37:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jTS8IRf1hEbRKBOj/p3qZ2dUXR46pYnRr+NOgzRr4w0=;
        b=o09FLZqVo4uXZOHJybSqQfw4UCSywFlH7xY3sKExFnG0VlSk2HIcdxBa/1np6zQX3z
         YS1t1B7bC19qpeqjsk0DCkjjlcJSjt5ZBrdjesMLOujzvFWgvBDUUNbz4Lpkhp1cr8EE
         5bT+5UVnOmNQTcCjFEXLa0xp40wFxzqHELGxhKp/xm75HJnfyZnWvkvs35bqe9vjEY1n
         ay5Vaj41/Ymck8Depp2r4BwfdXYWfiZWN7EvWAPTPy3hJCRJzfw0QnhH+Fpr1ra7IdH3
         MxoxGmUo5Pcuj/Z/5JKct8tiSm+4KFpfeauXDmK0sYtzRr6zw1XHSVQBPA6FK3GH08RB
         zeuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jTS8IRf1hEbRKBOj/p3qZ2dUXR46pYnRr+NOgzRr4w0=;
        b=DeOFJpUolMLm6gho0XY02ngpTeWaasedl5IuE5Z0kCkVUIjftVcrauHp/klo4h3MJX
         N2SbcT8vR+aQZP9Jlq4ckxhZNCAXJ3Ou+EzxQTZIcc8fKuEe9OKyeKl+n09oJPrOzEWj
         mgKRQTY2QwRgMP0yFRdL0mbg7iRkJxQGD4E1J+9RGaCFkDTxzYjSRPDIKDGyIP7N+96g
         TGf/xdycXLA10GcOpp37YvNHN+wtXI3EUu/XOvO8HBFkDX+q6t31UmFwcEIwMF7b5ZWS
         Do5xaSOx4Ntm/bKnIe50aKUoaDYo0w6m5GBSa8YGHBp+jz9nVPXblaeYgZzHUvMcAiQQ
         7wmQ==
X-Gm-Message-State: AOAM530ES8TazIWW7zqpwhpdRCT8fHB/wexBMeUKconshioEBuB8KaKC
        frzhwtA5BjaUNlhiHgV/10lR8bkg+5T7dT4lC/Y=
X-Google-Smtp-Source: ABdhPJxSKAfGFdG1cXK+tNCWtU1nG/1aQidC/ODzr8v+wwV5scrED+lSGL2xvd5qJlapy38FJyXyVHHvHyqWeI2aSb8=
X-Received: by 2002:a50:eb81:: with SMTP id y1mr7294222edr.176.1611956270672;
 Fri, 29 Jan 2021 13:37:50 -0800 (PST)
MIME-Version: 1.0
References: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 29 Jan 2021 16:37:14 -0500
Message-ID: <CAF=yD-JSdgTnXwVukkvHYNspWzJf0zrx2Qqfv3XHcbkvQ+Hs_g@mail.gmail.com>
Subject: Re: [PATCH net-next 00/15][pull request] 100GbE Intel Wired LAN
 Driver Updates 2021-01-28
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        sassmann@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 7:44 PM Tony Nguyen <anthony.l.nguyen@intel.com> wrote:
>
> This series contains updates to ice driver only.
>
> Jake adds devlink reporting of security revision fields associated with
> 'fw.undi' and 'fw.mgmt'. Also implements support for displaying and
> updating the minimum security revision fields for the device as
> driver-specific devlink parameters. And adds reporting of timeout length
> during devlink flash.
>
> He also implements support to report devlink info regarding the version of
> firmware that is stored (downloaded) to the device, but is not yet active.
> This includes the UNDI Option ROM, the Netlist module, and the
> fw.bundle_id.
>
> Changes include:
>    Refactoring version reporting to allow for a context structure.
>
>    ice_read_flash_module is further abstracted to think in terms of
>    "active" and "inactive" banks, rather than focusing on "read from
>    the 1st or 2nd bank". Further, the function is extended to allow
>    reading arbitrary sizes beyond just one word at a time.
>
>    Extend the version function to allow requesting the flash bank to read
>    from (active or inactive).
>
> Gustavo A. R. Silva replaces a one-element array to flexible-array
> member.
>
> Bruce utilizes flex_array_size() helper and removes dead code on a check
> for a condition that can't occur.
>
> The following are changes since commit 32e31b78272ba0905c751a0f6ff6ab4c275a780e:
>   Merge branch 'net-sfp-add-support-for-gpon-rtl8672-rtl9601c-and-ubiquiti-u-fiber'
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE
>
> Bruce Allan (2):
>   ice: use flex_array_size where possible
>   ice: remove dead code
>
> Gustavo A. R. Silva (1):
>   ice: Replace one-element array with flexible-array member
>
> Jacob Keller (12):
>   ice: create flash_info structure and separate NVM version
>   ice: cache NVM module bank information
>   ice: read security revision to ice_nvm_info and ice_orom_info
>   ice: add devlink parameters to read and write minimum security
>     revision
>   ice: report timeout length for erasing during devlink flash
>   ice: introduce context struct for info report
>   ice: refactor interface for ice_read_flash_module
>   ice: allow reading inactive flash security revision
>   ice: allow reading arbitrary size data with read_flash_module
>   ice: display some stored NVM versions via devlink info
>   ice: display stored netlist versions via devlink info
>   ice: display stored UNDI firmware version via devlink info
>
>  Documentation/networking/devlink/ice.rst      |  43 +
>  drivers/net/ethernet/intel/ice/ice.h          |   2 +-
>  .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  40 +-
>  drivers/net/ethernet/intel/ice/ice_common.c   |   2 +-
>  drivers/net/ethernet/intel/ice/ice_devlink.c  | 496 +++++++++-
>  drivers/net/ethernet/intel/ice/ice_devlink.h  |   2 +
>  drivers/net/ethernet/intel/ice/ice_ethtool.c  |   8 +-
>  .../net/ethernet/intel/ice/ice_flex_pipe.c    |   2 +-
>  .../net/ethernet/intel/ice/ice_fw_update.c    |  10 +-
>  drivers/net/ethernet/intel/ice/ice_main.c     |  19 +-
>  drivers/net/ethernet/intel/ice/ice_nvm.c      | 876 +++++++++++++++---
>  drivers/net/ethernet/intel/ice/ice_nvm.h      |  18 +
>  drivers/net/ethernet/intel/ice/ice_status.h   |   1 +
>  drivers/net/ethernet/intel/ice/ice_type.h     | 141 ++-
>  14 files changed, 1427 insertions(+), 233 deletions(-)

For netdrv

Acked-by: Willem de Bruijn <willemb@google.com>

Very clear code and documentation, thanks!
