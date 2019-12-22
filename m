Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78224128C78
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 04:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfLVDZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 22:25:45 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:35698 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbfLVDZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 22:25:45 -0500
Received: by mail-ot1-f67.google.com with SMTP id k16so12816492otb.2
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 19:25:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DJi2qrk5ym9fE8ZTEdz0RS4uJ2R4rLim5ar2kTNsPOg=;
        b=OHn9iykOxVCYwilHFhqE0yCvSI1/XC/5prpF6lka0oo9i2WyaQAGoiWjPOZsuV/tr1
         5zrixtgf21OINQqcbcmTToKD7e1D7jCGGQrSAWIMuLfQ7tieGOj0QZq7wHhVyoY1Qze+
         lMY+S73vO4jJjNogQYALxZoNBVxfk0uvTShl25AjB5b6WnGrYGt/qi5lzTfd6Jv3SLPG
         y6ZA7gyel122Qna7PX/AigfdbEPLXapwgPDmozx9NtjJCpm9uzjiXPZUtY3q2MOn2d02
         cjSUvqXjkiPytdcQIUFFhyDCb/Qjp2crIX29f4Z1ytuCdefzn81F+uP1isGv0/fGKW9n
         7q1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DJi2qrk5ym9fE8ZTEdz0RS4uJ2R4rLim5ar2kTNsPOg=;
        b=qKPXwKZweNVgKIyIbTTX34FXka+/TySwOPV5FxQRfTLlvETbF7pGUlSGI2imL0RRy5
         O2i+lG7wtobizYvLIIhM1sm3WjGavEFSjkEpMwFs6H0ZgvrIo2skiemG/vBfUqIQnNG3
         fnTRMdeD/WuuxXucCUYVknXAB193QBJtuIcZGZD8Z6BY4LteBOSi9m9FkFqIOwOVeNXa
         vwMu0Ca4nNMULrZb+Tz6xTm0gOf/a4dly5AuLNOzYwSWFk6u4XQi96bgaFx6R+PiANw+
         Q5xUcEZv5P0aX6/en7zRujtr9146KCMXTl5qv9WBPBMavrZbNYxd0BeLnktbQ53ax3+k
         o2EA==
X-Gm-Message-State: APjAAAU5Y1tz10VHZ40cVpa9LHnRenWjScO7o1vKdDNXdETd2KEovy5J
        KQUGU7KgEhzHPiVudX3fYhYRrnyB
X-Google-Smtp-Source: APXvYqyUyHLi5eW1VAKceI6LLdkrQQ+wW9ZqdK3vyQ552fPuud6wbCoZB5Xi8vP0v2r6Ev1Dfk3asA==
X-Received: by 2002:a05:6830:2057:: with SMTP id f23mr20822545otp.110.1576985144279;
        Sat, 21 Dec 2019 19:25:44 -0800 (PST)
Received: from ubuntu-m2-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id v14sm5402749oto.16.2019.12.21.19.25.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 21 Dec 2019 19:25:43 -0800 (PST)
Date:   Sat, 21 Dec 2019 20:25:42 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     kbuild@lists.01.org, Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com,
        kbuild test robot <lkp@intel.com>, netdev@vger.kernel.org
Subject: Re: [jkirsher-net-queue:dev-queue 5/5]
 drivers/net/ethernet/intel/e1000e/netdev.c:7604:7: warning: address of
 function 'down' will always evaluate to 'true'
Message-ID: <20191222032542.GA44059@ubuntu-m2-xlarge-x86>
References: <201912220313.FgL3fS3o%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201912220313.FgL3fS3o%lkp@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jeff,

We received this build report from the 0day team with clang, seems
legit. Mind taking a look into it?

Cheers,
Nathan

On Sun, Dec 22, 2019 at 03:36:15AM +0800, kbuild test robot wrote:
> CC: kbuild-all@lists.01.org
> CC: intel-wired-lan@lists.osuosl.org
> TO: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/net-queue.git dev-queue
> head:   831655569c70675c1622f8c52ed271dc7fdce42f
> commit: 831655569c70675c1622f8c52ed271dc7fdce42f [5/5] e1000e: Revert "e1000e: Make watchdog use delayed work"
> config: arm64-defconfig (attached as .config)
> compiler: clang version 10.0.0 (git://gitmirror/llvm_project 3ced23976aa8a86a17017c87821c873b4ca80bc2)
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 831655569c70675c1622f8c52ed271dc7fdce42f
>         # save the attached .config to linux build tree
>         make.cross ARCH=arm64 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
> >> drivers/net/ethernet/intel/e1000e/netdev.c:7604:7: warning: address of function 'down' will always evaluate to 'true' [-Wpointer-bool-conversion]
>            if (!down)
>                ~^~~~
>    drivers/net/ethernet/intel/e1000e/netdev.c:7604:7: note: prefix with the address-of operator to silence this warning
>            if (!down)
>                 ^
>                 &
>    1 warning generated.
> 
> vim +7604 drivers/net/ethernet/intel/e1000e/netdev.c
> 
>   7584	
>   7585	/**
>   7586	 * e1000_remove - Device Removal Routine
>   7587	 * @pdev: PCI device information struct
>   7588	 *
>   7589	 * e1000_remove is called by the PCI subsystem to alert the driver
>   7590	 * that it should release a PCI device.  The could be caused by a
>   7591	 * Hot-Plug event, or because the driver is going to be removed from
>   7592	 * memory.
>   7593	 **/
>   7594	static void e1000_remove(struct pci_dev *pdev)
>   7595	{
>   7596		struct net_device *netdev = pci_get_drvdata(pdev);
>   7597		struct e1000_adapter *adapter = netdev_priv(netdev);
>   7598	
>   7599		e1000e_ptp_remove(adapter);
>   7600	
>   7601		/* The timers may be rescheduled, so explicitly disable them
>   7602		 * from being rescheduled.
>   7603		 */
> > 7604		if (!down)
>   7605			set_bit(__E1000_DOWN, &adapter->state);
>   7606		del_timer_sync(&adapter->watchdog_timer);
>   7607		del_timer_sync(&adapter->phy_info_timer);
>   7608	
>   7609		cancel_work_sync(&adapter->reset_task);
>   7610		cancel_work_sync(&adapter->watchdog_task);
>   7611		cancel_work_sync(&adapter->downshift_task);
>   7612		cancel_work_sync(&adapter->update_phy_task);
>   7613		cancel_work_sync(&adapter->print_hang_task);
>   7614	
>   7615		if (adapter->flags & FLAG_HAS_HW_TIMESTAMP) {
>   7616			cancel_work_sync(&adapter->tx_hwtstamp_work);
>   7617			if (adapter->tx_hwtstamp_skb) {
>   7618				dev_consume_skb_any(adapter->tx_hwtstamp_skb);
>   7619				adapter->tx_hwtstamp_skb = NULL;
>   7620			}
>   7621		}
>   7622	
>   7623		unregister_netdev(netdev);
>   7624	
>   7625		if (pci_dev_run_wake(pdev))
>   7626			pm_runtime_get_noresume(&pdev->dev);
>   7627	
>   7628		/* Release control of h/w to f/w.  If f/w is AMT enabled, this
>   7629		 * would have already happened in close and is redundant.
>   7630		 */
>   7631		e1000e_release_hw_control(adapter);
>   7632	
>   7633		e1000e_reset_interrupt_capability(adapter);
>   7634		kfree(adapter->tx_ring);
>   7635		kfree(adapter->rx_ring);
>   7636	
>   7637		iounmap(adapter->hw.hw_addr);
>   7638		if ((adapter->hw.flash_address) &&
>   7639		    (adapter->hw.mac.type < e1000_pch_spt))
>   7640			iounmap(adapter->hw.flash_address);
>   7641		pci_release_mem_regions(pdev);
>   7642	
>   7643		free_netdev(netdev);
>   7644	
>   7645		/* AER disable */
>   7646		pci_disable_pcie_error_reporting(pdev);
>   7647	
>   7648		pci_disable_device(pdev);
>   7649	}
>   7650	
> 
> ---
> 0-DAY kernel test infrastructure                 Open Source Technology Center
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
> 
> -- 
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/201912220313.FgL3fS3o%25lkp%40intel.com.


